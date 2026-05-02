import 'package:flutter/material.dart';

/// Candela brand colors — ported from globals.css design tokens.
class CandelaColors {
  CandelaColors._();

  // ── Backgrounds ──
  static const bgPrimary = Color(0xFF0A0A0F);
  static const bgSecondary = Color(0xFF12121A);
  static const bgTertiary = Color(0xFF1A1A2E);
  static const bgElevated = Color(0xFF1E1E32);
  static const bgHover = Color(0xFF252540);

  // ── Text ──
  static const textPrimary = Color(0xFFE8E8F0);
  static const textSecondary = Color(0xFF9898B0);
  static const textMuted = Color(0xFF606078);

  // ── Borders ──
  static const border = Color(0xFF2A2A40);
  static const borderSubtle = Color(0xFF1E1E30);

  // ── Brand — warm amber/gold ──
  static const accent = Color(0xFFF0A030);
  static const accentDim = Color(0x26F0A030); // 15% opacity
  static const accentHover = Color(0xFFF5B848);

  // ── Status ──
  static const success = Color(0xFF34D399);
  static const warning = Color(0xFFFBBF24);
  static const error = Color(0xFFF87171);
  static const info = Color(0xFF60A5FA);
}
