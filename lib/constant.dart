import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color primaryColor = Colors.white;
const Color secondaryColor = Color.fromARGB(255, 67, 160, 71);
const Color hoverColor = Color.fromARGB(142, 42, 105, 45);
const Color addColor = Color.fromARGB(255, 42, 108, 163);
const Color errorColor = Color.fromARGB(255, 195, 23, 23);
const Color warnColor = Color(0xFFFFC36D);
const Color doneColor = Color(0xFFA5E656);

const server = "http://localhost:8000";
const serverUrl = "$server/api/v1";

const apiImageUsers = "$server/uploads/users";
const apiImageProducts = "$server/uploads/products";

const BoxConstraints fixedMobileSize = BoxConstraints(maxWidth: 312);

TextStyle bodyLargeBold = kIsWeb
    ? GoogleFonts.plusJakartaSans(
        fontSize: 21,
        fontWeight: FontWeight.w700,
      )
    : const TextStyle(
        fontFamily: "PlusJakartaSans",
        fontSize: 21,
        fontWeight: FontWeight.w700,
      );
TextStyle labelLargeMed = bodyLargeBold.copyWith(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: const Color.fromRGBO(102, 112, 133, 1.0),
);
TextStyle titleSmall = bodyLargeBold.copyWith(fontSize: 14);
TextStyle labelMedBold = bodyLargeBold.copyWith(fontSize: 12);
TextStyle labelMedMed = bodyLargeBold.copyWith(
  fontSize: 12,
  color: primaryColor,
  fontWeight: FontWeight.w500,
);
TextStyle labelMedReg = bodyLargeBold.copyWith(
  fontSize: 12,
  fontWeight: FontWeight.w400,
);
InputDecoration textFieldStyle = InputDecoration(
  alignLabelWithHint: true,
  floatingLabelAlignment: FloatingLabelAlignment.start,
  hintStyle: labelLargeMed.copyWith(fontSize: 12, fontWeight: FontWeight.w200),
  fillColor: secondaryColor,
  contentPadding: const EdgeInsets.symmetric(
    vertical: 8,
    horizontal: 16,
  ),
  border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8))),
  focusedBorder: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(color: secondaryColor),
  ),
);
