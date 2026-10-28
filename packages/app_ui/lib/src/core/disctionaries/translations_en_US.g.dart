///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEnUs = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.enUs,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en-US>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	dynamic operator[](String key) => _meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$dialog$en_US dialog = Translations$dialog$en_US.internal(_root);
	late final Translations$error$en_US error = Translations$error$en_US.internal(_root);
}

// Path: dialog
class Translations$dialog$en_US {
	Translations$dialog$en_US.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en-US: 'Confirm'
	String get confirm => 'Confirm';

	/// en-US: 'Cancel'
	String get cancel => 'Cancel';
}

// Path: error
class Translations$error$en_US {
	Translations$error$en_US.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$error$network$en_US network = Translations$error$network$en_US.internal(_root);
}

// Path: error.network
class Translations$error$network$en_US {
	Translations$error$network$en_US.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$error$network$unknown$en_US unknown = Translations$error$network$unknown$en_US.internal(_root);
	late final Translations$error$network$k402$en_US k402 = Translations$error$network$k402$en_US.internal(_root);
	late final Translations$error$network$k403$en_US k403 = Translations$error$network$k403$en_US.internal(_root);
	late final Translations$error$network$k404$en_US k404 = Translations$error$network$k404$en_US.internal(_root);
	late final Translations$error$network$k408$en_US k408 = Translations$error$network$k408$en_US.internal(_root);
	late final Translations$error$network$k413$en_US k413 = Translations$error$network$k413$en_US.internal(_root);
	late final Translations$error$network$k500$en_US k500 = Translations$error$network$k500$en_US.internal(_root);
	late final Translations$error$network$k502$en_US k502 = Translations$error$network$k502$en_US.internal(_root);
	late final Translations$error$network$k503$en_US k503 = Translations$error$network$k503$en_US.internal(_root);
}

// Path: error.network.unknown
class Translations$error$network$unknown$en_US {
	Translations$error$network$unknown$en_US.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en-US: 'Try Again'
	String get buttonText => 'Try Again';

	/// en-US: 'Sorry, an error occurred. Please try again later.'
	String get text => 'Sorry, an error occurred. Please try again later.';
}

// Path: error.network.k402
class Translations$error$network$k402$en_US {
	Translations$error$network$k402$en_US.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en-US: 'Back'
	String get buttonText => 'Back';

	/// en-US: 'Sorry, you do not have access to this data. Please contact us if this is a mistake.'
	String get text => 'Sorry, you do not have access to this data. Please contact us if this is a mistake.';
}

// Path: error.network.k403
class Translations$error$network$k403$en_US {
	Translations$error$network$k403$en_US.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en-US: 'Back'
	String get buttonText => 'Back';

	/// en-US: 'You do not have permission to access this page. Please ensure you have the appropriate access rights or contact us if there is an error.'
	String get text => 'You do not have permission to access this page. Please ensure you have the appropriate access rights or contact us if there is an error.';
}

// Path: error.network.k404
class Translations$error$network$k404$en_US {
	Translations$error$network$k404$en_US.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en-US: 'Back'
	String get buttonText => 'Back';

	/// en-US: 'Sorry, the page you are looking for cannot be found. The URL might be incorrect or the page has been removed. Please check again and try.'
	String get text => 'Sorry, the page you are looking for cannot be found. The URL might be incorrect or the page has been removed. Please check again and try.';
}

// Path: error.network.k408
class Translations$error$network$k408$en_US {
	Translations$error$network$k408$en_US.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en-US: 'Try Again'
	String get buttonText => 'Try Again';

	/// en-US: 'Sorry, your request could not be processed in the specified time. Please check your internet connection and try again.'
	String get text => 'Sorry, your request could not be processed in the specified time. Please check your internet connection and try again.';
}

// Path: error.network.k413
class Translations$error$network$k413$en_US {
	Translations$error$network$k413$en_US.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en-US: 'Try Again'
	String get buttonText => 'Try Again';

	/// en-US: 'The size of the data you submitted exceeds the allowed limit. Please reduce the size of the data or choose a different submission method.'
	String get text => 'The size of the data you submitted exceeds the allowed limit. Please reduce the size of the data or choose a different submission method.';
}

// Path: error.network.k500
class Translations$error$network$k500$en_US {
	Translations$error$network$k500$en_US.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en-US: 'Try Again'
	String get buttonText => 'Try Again';

	/// en-US: 'An internal server error occurred. Our team is working to fix this issue, please try again later.'
	String get text => 'An internal server error occurred. Our team is working to fix this issue, please try again later.';
}

// Path: error.network.k502
class Translations$error$network$k502$en_US {
	Translations$error$network$k502$en_US.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en-US: 'Try Again'
	String get buttonText => 'Try Again';

	/// en-US: 'There seems to be a problem with the server gateway. We are working to fix this issue. Please try again in a moment.'
	String get text => 'There seems to be a problem with the server gateway. We are working to fix this issue. Please try again in a moment.';
}

// Path: error.network.k503
class Translations$error$network$k503$en_US {
	Translations$error$network$k503$en_US.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en-US: 'Try Again'
	String get buttonText => 'Try Again';

	/// en-US: 'Sorry, the service is currently unavailable. We are undergoing maintenance or experiencing technical issues. Please try again later.'
	String get text => 'Sorry, the service is currently unavailable. We are undergoing maintenance or experiencing technical issues. Please try again later.';
}

/// The flat map containing all translations for locale <en-US>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'dialog.confirm' => 'Confirm',
			'dialog.cancel' => 'Cancel',
			'error.network.unknown.buttonText' => 'Try Again',
			'error.network.unknown.text' => 'Sorry, an error occurred. Please try again later.',
			'error.network.k402.buttonText' => 'Back',
			'error.network.k402.text' => 'Sorry, you do not have access to this data. Please contact us if this is a mistake.',
			'error.network.k403.buttonText' => 'Back',
			'error.network.k403.text' => 'You do not have permission to access this page. Please ensure you have the appropriate access rights or contact us if there is an error.',
			'error.network.k404.buttonText' => 'Back',
			'error.network.k404.text' => 'Sorry, the page you are looking for cannot be found. The URL might be incorrect or the page has been removed. Please check again and try.',
			'error.network.k408.buttonText' => 'Try Again',
			'error.network.k408.text' => 'Sorry, your request could not be processed in the specified time. Please check your internet connection and try again.',
			'error.network.k413.buttonText' => 'Try Again',
			'error.network.k413.text' => 'The size of the data you submitted exceeds the allowed limit. Please reduce the size of the data or choose a different submission method.',
			'error.network.k500.buttonText' => 'Try Again',
			'error.network.k500.text' => 'An internal server error occurred. Our team is working to fix this issue, please try again later.',
			'error.network.k502.buttonText' => 'Try Again',
			'error.network.k502.text' => 'There seems to be a problem with the server gateway. We are working to fix this issue. Please try again in a moment.',
			'error.network.k503.buttonText' => 'Try Again',
			'error.network.k503.text' => 'Sorry, the service is currently unavailable. We are undergoing maintenance or experiencing technical issues. Please try again later.',
			_ => null,
		};
	}
}
