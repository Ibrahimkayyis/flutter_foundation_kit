///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsIdId extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsIdId({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.idId,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <id-ID>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsIdId _root = this; // ignore: unused_field

	@override 
	TranslationsIdId $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsIdId(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$dialog$id_ID dialog = _Translations$dialog$id_ID._(_root);
	@override late final _Translations$error$id_ID error = _Translations$error$id_ID._(_root);
}

// Path: dialog
class _Translations$dialog$id_ID extends Translations$dialog$en_US {
	_Translations$dialog$id_ID._(TranslationsIdId root) : this._root = root, super.internal(root);

	final TranslationsIdId _root; // ignore: unused_field

	// Translations
	@override String get confirm => 'Konfirmasi';
	@override String get cancel => 'Batal';
}

// Path: error
class _Translations$error$id_ID extends Translations$error$en_US {
	_Translations$error$id_ID._(TranslationsIdId root) : this._root = root, super.internal(root);

	final TranslationsIdId _root; // ignore: unused_field

	// Translations
	@override late final _Translations$error$network$id_ID network = _Translations$error$network$id_ID._(_root);
}

// Path: error.network
class _Translations$error$network$id_ID extends Translations$error$network$en_US {
	_Translations$error$network$id_ID._(TranslationsIdId root) : this._root = root, super.internal(root);

	final TranslationsIdId _root; // ignore: unused_field

	// Translations
	@override late final _Translations$error$network$unknown$id_ID unknown = _Translations$error$network$unknown$id_ID._(_root);
	@override late final _Translations$error$network$k402$id_ID k402 = _Translations$error$network$k402$id_ID._(_root);
	@override late final _Translations$error$network$k403$id_ID k403 = _Translations$error$network$k403$id_ID._(_root);
	@override late final _Translations$error$network$k404$id_ID k404 = _Translations$error$network$k404$id_ID._(_root);
	@override late final _Translations$error$network$k408$id_ID k408 = _Translations$error$network$k408$id_ID._(_root);
	@override late final _Translations$error$network$k413$id_ID k413 = _Translations$error$network$k413$id_ID._(_root);
	@override late final _Translations$error$network$k500$id_ID k500 = _Translations$error$network$k500$id_ID._(_root);
	@override late final _Translations$error$network$k502$id_ID k502 = _Translations$error$network$k502$id_ID._(_root);
	@override late final _Translations$error$network$k503$id_ID k503 = _Translations$error$network$k503$id_ID._(_root);
}

// Path: error.network.unknown
class _Translations$error$network$unknown$id_ID extends Translations$error$network$unknown$en_US {
	_Translations$error$network$unknown$id_ID._(TranslationsIdId root) : this._root = root, super.internal(root);

	final TranslationsIdId _root; // ignore: unused_field

	// Translations
	@override String get buttonText => 'Coba Lagi';
	@override String get text => 'Mohon maaf terjadi kesalahan, silahkan coba lagi';
}

// Path: error.network.k402
class _Translations$error$network$k402$id_ID extends Translations$error$network$k402$en_US {
	_Translations$error$network$k402$id_ID._(TranslationsIdId root) : this._root = root, super.internal(root);

	final TranslationsIdId _root; // ignore: unused_field

	// Translations
	@override String get buttonText => 'Kembali';
	@override String get text => 'Mohon maaf, anda tidak memiliki akses ke data ini. Silahkan hubungi kami apabila ini adalah sebuah kesalahan.';
}

// Path: error.network.k403
class _Translations$error$network$k403$id_ID extends Translations$error$network$k403$en_US {
	_Translations$error$network$k403$id_ID._(TranslationsIdId root) : this._root = root, super.internal(root);

	final TranslationsIdId _root; // ignore: unused_field

	// Translations
	@override String get buttonText => 'Kembali';
	@override String get text => 'Anda tidak memiliki izin untuk mengakses halaman ini. Silakan pastikan Anda memiliki hak akses yang sesuai atau hubungi kami bila terjadi kealahan.';
}

// Path: error.network.k404
class _Translations$error$network$k404$id_ID extends Translations$error$network$k404$en_US {
	_Translations$error$network$k404$id_ID._(TranslationsIdId root) : this._root = root, super.internal(root);

	final TranslationsIdId _root; // ignore: unused_field

	// Translations
	@override String get buttonText => 'Kembali';
	@override String get text => 'Mohon maaf, halaman yang Anda cari tidak dapat ditemukan. URL mungkin salah atau halaman telah dihapus. Silakan periksa kembali dan coba lagi.';
}

// Path: error.network.k408
class _Translations$error$network$k408$id_ID extends Translations$error$network$k408$en_US {
	_Translations$error$network$k408$id_ID._(TranslationsIdId root) : this._root = root, super.internal(root);

	final TranslationsIdId _root; // ignore: unused_field

	// Translations
	@override String get buttonText => 'Coba Lagi';
	@override String get text => 'Mohon maaf, permintaan Anda tidak dapat diproses dalam waktu yang ditentukan. Silakan periksa koneksi internet Anda dan coba lagi.';
}

// Path: error.network.k413
class _Translations$error$network$k413$id_ID extends Translations$error$network$k413$en_US {
	_Translations$error$network$k413$id_ID._(TranslationsIdId root) : this._root = root, super.internal(root);

	final TranslationsIdId _root; // ignore: unused_field

	// Translations
	@override String get buttonText => 'Coba Lagi';
	@override String get text => 'Ukuran data yang Anda kirimkan melebihi batas yang diizinkan. Silakan perkecil ukuran data atau pilih metode pengiriman yang berbeda.';
}

// Path: error.network.k500
class _Translations$error$network$k500$id_ID extends Translations$error$network$k500$en_US {
	_Translations$error$network$k500$id_ID._(TranslationsIdId root) : this._root = root, super.internal(root);

	final TranslationsIdId _root; // ignore: unused_field

	// Translations
	@override String get buttonText => 'Coba Lagi';
	@override String get text => 'Terjadi kesalahan internal pada server. Tim kami sedang berusaha memperbaiki masalah ini, mohon coba beberapa saat lagi ya';
}

// Path: error.network.k502
class _Translations$error$network$k502$id_ID extends Translations$error$network$k502$en_US {
	_Translations$error$network$k502$id_ID._(TranslationsIdId root) : this._root = root, super.internal(root);

	final TranslationsIdId _root; // ignore: unused_field

	// Translations
	@override String get buttonText => 'Coba Lagi';
	@override String get text => 'Tampaknya ada masalah pada gateway server. Kami sedang bekerja untuk memperbaiki masalah ini. Mohon coba lagi dalam beberapa saat';
}

// Path: error.network.k503
class _Translations$error$network$k503$id_ID extends Translations$error$network$k503$en_US {
	_Translations$error$network$k503$id_ID._(TranslationsIdId root) : this._root = root, super.internal(root);

	final TranslationsIdId _root; // ignore: unused_field

	// Translations
	@override String get buttonText => 'Coba Lagi';
	@override String get text => 'Maaf, layanan tidak tersedia saat ini. Kami sedang melakukan pemeliharaan atau mengalami masalah teknis. Silakan coba beberapa saat lagi.';
}

/// The flat map containing all translations for locale <id-ID>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsIdId {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'dialog.confirm' => 'Konfirmasi',
			'dialog.cancel' => 'Batal',
			'error.network.unknown.buttonText' => 'Coba Lagi',
			'error.network.unknown.text' => 'Mohon maaf terjadi kesalahan, silahkan coba lagi',
			'error.network.k402.buttonText' => 'Kembali',
			'error.network.k402.text' => 'Mohon maaf, anda tidak memiliki akses ke data ini. Silahkan hubungi kami apabila ini adalah sebuah kesalahan.',
			'error.network.k403.buttonText' => 'Kembali',
			'error.network.k403.text' => 'Anda tidak memiliki izin untuk mengakses halaman ini. Silakan pastikan Anda memiliki hak akses yang sesuai atau hubungi kami bila terjadi kealahan.',
			'error.network.k404.buttonText' => 'Kembali',
			'error.network.k404.text' => 'Mohon maaf, halaman yang Anda cari tidak dapat ditemukan. URL mungkin salah atau halaman telah dihapus. Silakan periksa kembali dan coba lagi.',
			'error.network.k408.buttonText' => 'Coba Lagi',
			'error.network.k408.text' => 'Mohon maaf, permintaan Anda tidak dapat diproses dalam waktu yang ditentukan. Silakan periksa koneksi internet Anda dan coba lagi.',
			'error.network.k413.buttonText' => 'Coba Lagi',
			'error.network.k413.text' => 'Ukuran data yang Anda kirimkan melebihi batas yang diizinkan. Silakan perkecil ukuran data atau pilih metode pengiriman yang berbeda.',
			'error.network.k500.buttonText' => 'Coba Lagi',
			'error.network.k500.text' => 'Terjadi kesalahan internal pada server. Tim kami sedang berusaha memperbaiki masalah ini, mohon coba beberapa saat lagi ya',
			'error.network.k502.buttonText' => 'Coba Lagi',
			'error.network.k502.text' => 'Tampaknya ada masalah pada gateway server. Kami sedang bekerja untuk memperbaiki masalah ini. Mohon coba lagi dalam beberapa saat',
			'error.network.k503.buttonText' => 'Coba Lagi',
			'error.network.k503.text' => 'Maaf, layanan tidak tersedia saat ini. Kami sedang melakukan pemeliharaan atau mengalami masalah teknis. Silakan coba beberapa saat lagi.',
			_ => null,
		};
	}
}
