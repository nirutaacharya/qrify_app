import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';

// ─── Colour Palette ───────────────────────────────────────────────
const _bg            = Color.fromARGB(255, 255, 255, 255); // warm cream background
const _surface       = Color(0xFFFAF7F2); // lighter card surface
const _border        = Color(0xFFE2D9CC); // muted warm border
const _accent        = Color(0xFF7C6A52); // warm brown accent
const _accentSoft    = Color(0xFFB5A48E); // softer warm brown
const _textPrimary   = Color(0xFF3A2E22); // deep warm brown text
const _textSecondary = Color(0xFF8C7D6B); // muted body text
const _errorColor    = Color(0xFFC0392B);
// ──────────────────────────────────────────────────────────────────

void main() {
  runApp(const QRifyApp());
}

class QRifyApp extends StatelessWidget {
  const QRifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QRify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _bg,
        colorScheme: const ColorScheme.light(
          primary: _accent,
          surface: _surface,
          onPrimary: Colors.white,
          onSurface: _textPrimary,
        ),
      ),
      home: const QRGeneratorScreen(),
    );
  }
}

class QRGeneratorScreen extends StatefulWidget {
  const QRGeneratorScreen({super.key});

  @override
  State<QRGeneratorScreen> createState() => _QRGeneratorScreenState();
}

class _QRGeneratorScreenState extends State<QRGeneratorScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Uint8List? _qrImageBytes;
  bool _isLoading = false;
  String? _errorMessage;
  String? _lastGeneratedData;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://147.93.19.205:3000/api',
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _dio.close();
    super.dispose();
  }

  Future<void> _generateQR() async {
    final data = _controller.text.trim();

    if (data.isEmpty) {
      setState(() => _errorMessage = 'Please enter some text or a URL.');
      return;
    }

    if (data == _lastGeneratedData && _qrImageBytes != null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    _focusNode.unfocus();

    try {
      final response = await _dio.post<dynamic>(
        '/qr/generate',
        data: {'data': data},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          responseType: ResponseType.bytes,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          _qrImageBytes = Uint8List.fromList(response.data as List<int>);
          _lastGeneratedData = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to generate QR code.';
          _isLoading = false;
        });
      }
    } on DioException catch (e) {
      String msg = 'Network error. Check your connection.';
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        msg = 'Request timed out. Please try again.';
      } else if (e.response != null) {
        msg = 'Server error (${e.response?.statusCode}).';
      }
      setState(() {
        _errorMessage = msg;
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _errorMessage = 'An unexpected error occurred.';
        _isLoading = false;
      });
    }
  }

  void _clearAll() {
    setState(() {
      _controller.clear();
      _qrImageBytes = null;
      _errorMessage = null;
      _lastGeneratedData = null;
    });
  }

  void _copyToClipboard() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Copied to clipboard',
          style: TextStyle(color: _textPrimary, fontSize: 13),
        ),
        backgroundColor: _surface,
        behavior: SnackBarBehavior.floating,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: _border),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 36),

              // ── Header ────────────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _accent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.qr_code_2_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'QRify',
                    style: TextStyle(
                      color: _textPrimary,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  if (_qrImageBytes != null)
                    GestureDetector(
                      onTap: _clearAll,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: _surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _border),
                        ),
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            color: _textSecondary,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 6),
              const Text(
                'Generate QR codes instantly',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 36),

              // ── Input Label ──────────────────────────────────
              const Text(
                'URL OR TEXT',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),

              // ── Text Field ───────────────────────────────────
              Container(
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _border),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  style: const TextStyle(
                    color: _textPrimary,
                    fontSize: 15,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: 'https://example.com or any text…',
                    hintStyle: const TextStyle(
                      color: _accentSoft,
                      fontSize: 15,
                    ),
                    contentPadding: const EdgeInsets.all(14),
                    border: InputBorder.none,
                    suffixIcon: _controller.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded,
                                color: _accentSoft, size: 18),
                            onPressed: () {
                              _controller.clear();
                              setState(() => _errorMessage = null);
                            },
                          )
                        : null,
                  ),
                  onChanged: (_) => setState(() => _errorMessage = null),
                  onSubmitted: (_) => _generateQR(),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  cursorColor: _accent,
                ),
              ),

              // ── Error ─────────────────────────────────────────
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: _errorColor, size: 15),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: _errorColor,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 18),

              // ── Generate Button ──────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _generateQR,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _accent,
                    disabledBackgroundColor: _accentSoft,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code_rounded,
                                size: 19, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              'Generate QR Code',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 32),
              const Divider(color: _border, thickness: 1),
              const SizedBox(height: 28),

              // ── QR Result ─────────────────────────────────────
              if (_qrImageBytes != null) ...[
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: _accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'QR CODE READY',
                      style: TextStyle(
                        color: _accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _border),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // QR Image in white frame
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _border),
                        ),
                        child: Image.memory(
                          _qrImageBytes!,
                          width: 210,
                          height: 210,
                          fit: BoxFit.contain,
                          gaplessPlayback: true,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Data preview
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: _bg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _border),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _lastGeneratedData ?? '',
                                style: const TextStyle(
                                  color: _textSecondary,
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: _copyToClipboard,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: _surface,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: _border),
                                ),
                                child: const Icon(
                                  Icons.copy_rounded,
                                  color: _textSecondary,
                                  size: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ] else ...[
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: _surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _border),
                        ),
                        child: const Icon(
                          Icons.qr_code_2_rounded,
                          color: _border,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Your QR code will appear here',
                        style: TextStyle(
                          color: _accentSoft,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}