import 'package:flutter/material.dart';

class AppTheme {
  //* headline 1
  //لما ارجع بيانات ممكن تكون null
  //اما بستخد ؟؟ او بستخدم ! بتحكي مستحيل ترجع null
  //    Theme.of(context).textTheme.headlineLarge !
//! : بتعمل مشاكل اذا رجعت null
  static TextStyle hLarge(BuildContext context) =>
      Theme.of(context).textTheme.headlineLarge ??
      const TextStyle(); //حتى ما يرجع null

  static TextStyle hmeduim(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium ?? const TextStyle();

  static TextStyle hsmall(BuildContext context) =>
      Theme.of(context).textTheme.headlineSmall ?? const TextStyle();

//*bodyText 1
  static TextStyle blarge(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge ?? const TextStyle();

  static TextStyle bmeduim(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium ?? const TextStyle();
  static TextStyle bsmall(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall ?? const TextStyle();
}
