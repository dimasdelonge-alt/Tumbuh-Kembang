// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PatientsTable extends Patients with TableInfo<$PatientsTable, Patient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PatientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => _uuid.v4(),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _medicalRecordNoMeta = const VerificationMeta(
    'medicalRecordNo',
  );
  @override
  late final GeneratedColumn<String> medicalRecordNo = GeneratedColumn<String>(
    'medical_record_no',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentNameMeta = const VerificationMeta(
    'parentName',
  );
  @override
  late final GeneratedColumn<String> parentName = GeneratedColumn<String>(
    'parent_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _gestationalWeeksMeta = const VerificationMeta(
    'gestationalWeeks',
  );
  @override
  late final GeneratedColumn<int> gestationalWeeks = GeneratedColumn<int>(
    'gestational_weeks',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPrematureMeta = const VerificationMeta(
    'isPremature',
  );
  @override
  late final GeneratedColumn<bool> isPremature = GeneratedColumn<bool>(
    'is_premature',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_premature" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hasDownSyndromeMeta = const VerificationMeta(
    'hasDownSyndrome',
  );
  @override
  late final GeneratedColumn<bool> hasDownSyndrome = GeneratedColumn<bool>(
    'has_down_syndrome',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_down_syndrome" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _fatherHeightCmMeta = const VerificationMeta(
    'fatherHeightCm',
  );
  @override
  late final GeneratedColumn<double> fatherHeightCm = GeneratedColumn<double>(
    'father_height_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _motherHeightCmMeta = const VerificationMeta(
    'motherHeightCm',
  );
  @override
  late final GeneratedColumn<double> motherHeightCm = GeneratedColumn<double>(
    'mother_height_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    medicalRecordNo,
    birthDate,
    sex,
    parentName,
    phone,
    address,
    gestationalWeeks,
    isPremature,
    hasDownSyndrome,
    fatherHeightCm,
    motherHeightCm,
    notes,
    createdAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'patients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Patient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('medical_record_no')) {
      context.handle(
        _medicalRecordNoMeta,
        medicalRecordNo.isAcceptableOrUnknown(
          data['medical_record_no']!,
          _medicalRecordNoMeta,
        ),
      );
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    } else if (isInserting) {
      context.missing(_birthDateMeta);
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    } else if (isInserting) {
      context.missing(_sexMeta);
    }
    if (data.containsKey('parent_name')) {
      context.handle(
        _parentNameMeta,
        parentName.isAcceptableOrUnknown(data['parent_name']!, _parentNameMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('gestational_weeks')) {
      context.handle(
        _gestationalWeeksMeta,
        gestationalWeeks.isAcceptableOrUnknown(
          data['gestational_weeks']!,
          _gestationalWeeksMeta,
        ),
      );
    }
    if (data.containsKey('is_premature')) {
      context.handle(
        _isPrematureMeta,
        isPremature.isAcceptableOrUnknown(
          data['is_premature']!,
          _isPrematureMeta,
        ),
      );
    }
    if (data.containsKey('has_down_syndrome')) {
      context.handle(
        _hasDownSyndromeMeta,
        hasDownSyndrome.isAcceptableOrUnknown(
          data['has_down_syndrome']!,
          _hasDownSyndromeMeta,
        ),
      );
    }
    if (data.containsKey('father_height_cm')) {
      context.handle(
        _fatherHeightCmMeta,
        fatherHeightCm.isAcceptableOrUnknown(
          data['father_height_cm']!,
          _fatherHeightCmMeta,
        ),
      );
    }
    if (data.containsKey('mother_height_cm')) {
      context.handle(
        _motherHeightCmMeta,
        motherHeightCm.isAcceptableOrUnknown(
          data['mother_height_cm']!,
          _motherHeightCmMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Patient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Patient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      medicalRecordNo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}medical_record_no'],
      ),
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      )!,
      sex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sex'],
      )!,
      parentName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_name'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      gestationalWeeks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gestational_weeks'],
      ),
      isPremature: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_premature'],
      )!,
      hasDownSyndrome: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_down_syndrome'],
      )!,
      fatherHeightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}father_height_cm'],
      ),
      motherHeightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}mother_height_cm'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $PatientsTable createAlias(String alias) {
    return $PatientsTable(attachedDatabase, alias);
  }
}

class Patient extends DataClass implements Insertable<Patient> {
  final String id;
  final String name;
  final String? medicalRecordNo;
  final DateTime birthDate;
  final String sex;
  final String? parentName;
  final String? phone;
  final String? address;

  /// Usia gestasi saat lahir (minggu). Null bila aterm/tidak diketahui.
  final int? gestationalWeeks;
  final bool isPremature;
  final bool hasDownSyndrome;
  final double? fatherHeightCm;
  final double? motherHeightCm;
  final String? notes;
  final DateTime createdAt;

  /// Null = aktif. Non-null = soft-deleted (tanggal penghapusan).
  final DateTime? deletedAt;
  const Patient({
    required this.id,
    required this.name,
    this.medicalRecordNo,
    required this.birthDate,
    required this.sex,
    this.parentName,
    this.phone,
    this.address,
    this.gestationalWeeks,
    required this.isPremature,
    required this.hasDownSyndrome,
    this.fatherHeightCm,
    this.motherHeightCm,
    this.notes,
    required this.createdAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || medicalRecordNo != null) {
      map['medical_record_no'] = Variable<String>(medicalRecordNo);
    }
    map['birth_date'] = Variable<DateTime>(birthDate);
    map['sex'] = Variable<String>(sex);
    if (!nullToAbsent || parentName != null) {
      map['parent_name'] = Variable<String>(parentName);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || gestationalWeeks != null) {
      map['gestational_weeks'] = Variable<int>(gestationalWeeks);
    }
    map['is_premature'] = Variable<bool>(isPremature);
    map['has_down_syndrome'] = Variable<bool>(hasDownSyndrome);
    if (!nullToAbsent || fatherHeightCm != null) {
      map['father_height_cm'] = Variable<double>(fatherHeightCm);
    }
    if (!nullToAbsent || motherHeightCm != null) {
      map['mother_height_cm'] = Variable<double>(motherHeightCm);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  PatientsCompanion toCompanion(bool nullToAbsent) {
    return PatientsCompanion(
      id: Value(id),
      name: Value(name),
      medicalRecordNo: medicalRecordNo == null && nullToAbsent
          ? const Value.absent()
          : Value(medicalRecordNo),
      birthDate: Value(birthDate),
      sex: Value(sex),
      parentName: parentName == null && nullToAbsent
          ? const Value.absent()
          : Value(parentName),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      gestationalWeeks: gestationalWeeks == null && nullToAbsent
          ? const Value.absent()
          : Value(gestationalWeeks),
      isPremature: Value(isPremature),
      hasDownSyndrome: Value(hasDownSyndrome),
      fatherHeightCm: fatherHeightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(fatherHeightCm),
      motherHeightCm: motherHeightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(motherHeightCm),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Patient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Patient(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      medicalRecordNo: serializer.fromJson<String?>(json['medicalRecordNo']),
      birthDate: serializer.fromJson<DateTime>(json['birthDate']),
      sex: serializer.fromJson<String>(json['sex']),
      parentName: serializer.fromJson<String?>(json['parentName']),
      phone: serializer.fromJson<String?>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      gestationalWeeks: serializer.fromJson<int?>(json['gestationalWeeks']),
      isPremature: serializer.fromJson<bool>(json['isPremature']),
      hasDownSyndrome: serializer.fromJson<bool>(json['hasDownSyndrome']),
      fatherHeightCm: serializer.fromJson<double?>(json['fatherHeightCm']),
      motherHeightCm: serializer.fromJson<double?>(json['motherHeightCm']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'medicalRecordNo': serializer.toJson<String?>(medicalRecordNo),
      'birthDate': serializer.toJson<DateTime>(birthDate),
      'sex': serializer.toJson<String>(sex),
      'parentName': serializer.toJson<String?>(parentName),
      'phone': serializer.toJson<String?>(phone),
      'address': serializer.toJson<String?>(address),
      'gestationalWeeks': serializer.toJson<int?>(gestationalWeeks),
      'isPremature': serializer.toJson<bool>(isPremature),
      'hasDownSyndrome': serializer.toJson<bool>(hasDownSyndrome),
      'fatherHeightCm': serializer.toJson<double?>(fatherHeightCm),
      'motherHeightCm': serializer.toJson<double?>(motherHeightCm),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Patient copyWith({
    String? id,
    String? name,
    Value<String?> medicalRecordNo = const Value.absent(),
    DateTime? birthDate,
    String? sex,
    Value<String?> parentName = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<int?> gestationalWeeks = const Value.absent(),
    bool? isPremature,
    bool? hasDownSyndrome,
    Value<double?> fatherHeightCm = const Value.absent(),
    Value<double?> motherHeightCm = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Patient(
    id: id ?? this.id,
    name: name ?? this.name,
    medicalRecordNo: medicalRecordNo.present
        ? medicalRecordNo.value
        : this.medicalRecordNo,
    birthDate: birthDate ?? this.birthDate,
    sex: sex ?? this.sex,
    parentName: parentName.present ? parentName.value : this.parentName,
    phone: phone.present ? phone.value : this.phone,
    address: address.present ? address.value : this.address,
    gestationalWeeks: gestationalWeeks.present
        ? gestationalWeeks.value
        : this.gestationalWeeks,
    isPremature: isPremature ?? this.isPremature,
    hasDownSyndrome: hasDownSyndrome ?? this.hasDownSyndrome,
    fatherHeightCm: fatherHeightCm.present
        ? fatherHeightCm.value
        : this.fatherHeightCm,
    motherHeightCm: motherHeightCm.present
        ? motherHeightCm.value
        : this.motherHeightCm,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Patient copyWithCompanion(PatientsCompanion data) {
    return Patient(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      medicalRecordNo: data.medicalRecordNo.present
          ? data.medicalRecordNo.value
          : this.medicalRecordNo,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      sex: data.sex.present ? data.sex.value : this.sex,
      parentName: data.parentName.present
          ? data.parentName.value
          : this.parentName,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      gestationalWeeks: data.gestationalWeeks.present
          ? data.gestationalWeeks.value
          : this.gestationalWeeks,
      isPremature: data.isPremature.present
          ? data.isPremature.value
          : this.isPremature,
      hasDownSyndrome: data.hasDownSyndrome.present
          ? data.hasDownSyndrome.value
          : this.hasDownSyndrome,
      fatherHeightCm: data.fatherHeightCm.present
          ? data.fatherHeightCm.value
          : this.fatherHeightCm,
      motherHeightCm: data.motherHeightCm.present
          ? data.motherHeightCm.value
          : this.motherHeightCm,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Patient(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('medicalRecordNo: $medicalRecordNo, ')
          ..write('birthDate: $birthDate, ')
          ..write('sex: $sex, ')
          ..write('parentName: $parentName, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('gestationalWeeks: $gestationalWeeks, ')
          ..write('isPremature: $isPremature, ')
          ..write('hasDownSyndrome: $hasDownSyndrome, ')
          ..write('fatherHeightCm: $fatherHeightCm, ')
          ..write('motherHeightCm: $motherHeightCm, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    medicalRecordNo,
    birthDate,
    sex,
    parentName,
    phone,
    address,
    gestationalWeeks,
    isPremature,
    hasDownSyndrome,
    fatherHeightCm,
    motherHeightCm,
    notes,
    createdAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Patient &&
          other.id == this.id &&
          other.name == this.name &&
          other.medicalRecordNo == this.medicalRecordNo &&
          other.birthDate == this.birthDate &&
          other.sex == this.sex &&
          other.parentName == this.parentName &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.gestationalWeeks == this.gestationalWeeks &&
          other.isPremature == this.isPremature &&
          other.hasDownSyndrome == this.hasDownSyndrome &&
          other.fatherHeightCm == this.fatherHeightCm &&
          other.motherHeightCm == this.motherHeightCm &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt);
}

class PatientsCompanion extends UpdateCompanion<Patient> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> medicalRecordNo;
  final Value<DateTime> birthDate;
  final Value<String> sex;
  final Value<String?> parentName;
  final Value<String?> phone;
  final Value<String?> address;
  final Value<int?> gestationalWeeks;
  final Value<bool> isPremature;
  final Value<bool> hasDownSyndrome;
  final Value<double?> fatherHeightCm;
  final Value<double?> motherHeightCm;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const PatientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.medicalRecordNo = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.sex = const Value.absent(),
    this.parentName = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.gestationalWeeks = const Value.absent(),
    this.isPremature = const Value.absent(),
    this.hasDownSyndrome = const Value.absent(),
    this.fatherHeightCm = const Value.absent(),
    this.motherHeightCm = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PatientsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.medicalRecordNo = const Value.absent(),
    required DateTime birthDate,
    required String sex,
    this.parentName = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.gestationalWeeks = const Value.absent(),
    this.isPremature = const Value.absent(),
    this.hasDownSyndrome = const Value.absent(),
    this.fatherHeightCm = const Value.absent(),
    this.motherHeightCm = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       birthDate = Value(birthDate),
       sex = Value(sex);
  static Insertable<Patient> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? medicalRecordNo,
    Expression<DateTime>? birthDate,
    Expression<String>? sex,
    Expression<String>? parentName,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<int>? gestationalWeeks,
    Expression<bool>? isPremature,
    Expression<bool>? hasDownSyndrome,
    Expression<double>? fatherHeightCm,
    Expression<double>? motherHeightCm,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (medicalRecordNo != null) 'medical_record_no': medicalRecordNo,
      if (birthDate != null) 'birth_date': birthDate,
      if (sex != null) 'sex': sex,
      if (parentName != null) 'parent_name': parentName,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (gestationalWeeks != null) 'gestational_weeks': gestationalWeeks,
      if (isPremature != null) 'is_premature': isPremature,
      if (hasDownSyndrome != null) 'has_down_syndrome': hasDownSyndrome,
      if (fatherHeightCm != null) 'father_height_cm': fatherHeightCm,
      if (motherHeightCm != null) 'mother_height_cm': motherHeightCm,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PatientsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? medicalRecordNo,
    Value<DateTime>? birthDate,
    Value<String>? sex,
    Value<String?>? parentName,
    Value<String?>? phone,
    Value<String?>? address,
    Value<int?>? gestationalWeeks,
    Value<bool>? isPremature,
    Value<bool>? hasDownSyndrome,
    Value<double?>? fatherHeightCm,
    Value<double?>? motherHeightCm,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return PatientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      medicalRecordNo: medicalRecordNo ?? this.medicalRecordNo,
      birthDate: birthDate ?? this.birthDate,
      sex: sex ?? this.sex,
      parentName: parentName ?? this.parentName,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      gestationalWeeks: gestationalWeeks ?? this.gestationalWeeks,
      isPremature: isPremature ?? this.isPremature,
      hasDownSyndrome: hasDownSyndrome ?? this.hasDownSyndrome,
      fatherHeightCm: fatherHeightCm ?? this.fatherHeightCm,
      motherHeightCm: motherHeightCm ?? this.motherHeightCm,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (medicalRecordNo.present) {
      map['medical_record_no'] = Variable<String>(medicalRecordNo.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (parentName.present) {
      map['parent_name'] = Variable<String>(parentName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (gestationalWeeks.present) {
      map['gestational_weeks'] = Variable<int>(gestationalWeeks.value);
    }
    if (isPremature.present) {
      map['is_premature'] = Variable<bool>(isPremature.value);
    }
    if (hasDownSyndrome.present) {
      map['has_down_syndrome'] = Variable<bool>(hasDownSyndrome.value);
    }
    if (fatherHeightCm.present) {
      map['father_height_cm'] = Variable<double>(fatherHeightCm.value);
    }
    if (motherHeightCm.present) {
      map['mother_height_cm'] = Variable<double>(motherHeightCm.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PatientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('medicalRecordNo: $medicalRecordNo, ')
          ..write('birthDate: $birthDate, ')
          ..write('sex: $sex, ')
          ..write('parentName: $parentName, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('gestationalWeeks: $gestationalWeeks, ')
          ..write('isPremature: $isPremature, ')
          ..write('hasDownSyndrome: $hasDownSyndrome, ')
          ..write('fatherHeightCm: $fatherHeightCm, ')
          ..write('motherHeightCm: $motherHeightCm, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExaminationsTable extends Examinations
    with TableInfo<$ExaminationsTable, Examination> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExaminationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => _uuid.v4(),
  );
  static const VerificationMeta _patientIdMeta = const VerificationMeta(
    'patientId',
  );
  @override
  late final GeneratedColumn<String> patientId = GeneratedColumn<String>(
    'patient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES patients (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _examDateMeta = const VerificationMeta(
    'examDate',
  );
  @override
  late final GeneratedColumn<DateTime> examDate = GeneratedColumn<DateTime>(
    'exam_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _examinerNoteMeta = const VerificationMeta(
    'examinerNote',
  );
  @override
  late final GeneratedColumn<String> examinerNote = GeneratedColumn<String>(
    'examiner_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    patientId,
    examDate,
    examinerNote,
    createdAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'examinations';
  @override
  VerificationContext validateIntegrity(
    Insertable<Examination> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('patient_id')) {
      context.handle(
        _patientIdMeta,
        patientId.isAcceptableOrUnknown(data['patient_id']!, _patientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_patientIdMeta);
    }
    if (data.containsKey('exam_date')) {
      context.handle(
        _examDateMeta,
        examDate.isAcceptableOrUnknown(data['exam_date']!, _examDateMeta),
      );
    } else if (isInserting) {
      context.missing(_examDateMeta);
    }
    if (data.containsKey('examiner_note')) {
      context.handle(
        _examinerNoteMeta,
        examinerNote.isAcceptableOrUnknown(
          data['examiner_note']!,
          _examinerNoteMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Examination map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Examination(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      patientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patient_id'],
      )!,
      examDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}exam_date'],
      )!,
      examinerNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}examiner_note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $ExaminationsTable createAlias(String alias) {
    return $ExaminationsTable(attachedDatabase, alias);
  }
}

class Examination extends DataClass implements Insertable<Examination> {
  final String id;
  final String patientId;
  final DateTime examDate;
  final String? examinerNote;
  final DateTime createdAt;

  /// Null = aktif. Non-null = soft-deleted (tanggal penghapusan).
  final DateTime? deletedAt;
  const Examination({
    required this.id,
    required this.patientId,
    required this.examDate,
    this.examinerNote,
    required this.createdAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['patient_id'] = Variable<String>(patientId);
    map['exam_date'] = Variable<DateTime>(examDate);
    if (!nullToAbsent || examinerNote != null) {
      map['examiner_note'] = Variable<String>(examinerNote);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ExaminationsCompanion toCompanion(bool nullToAbsent) {
    return ExaminationsCompanion(
      id: Value(id),
      patientId: Value(patientId),
      examDate: Value(examDate),
      examinerNote: examinerNote == null && nullToAbsent
          ? const Value.absent()
          : Value(examinerNote),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Examination.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Examination(
      id: serializer.fromJson<String>(json['id']),
      patientId: serializer.fromJson<String>(json['patientId']),
      examDate: serializer.fromJson<DateTime>(json['examDate']),
      examinerNote: serializer.fromJson<String?>(json['examinerNote']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'patientId': serializer.toJson<String>(patientId),
      'examDate': serializer.toJson<DateTime>(examDate),
      'examinerNote': serializer.toJson<String?>(examinerNote),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Examination copyWith({
    String? id,
    String? patientId,
    DateTime? examDate,
    Value<String?> examinerNote = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Examination(
    id: id ?? this.id,
    patientId: patientId ?? this.patientId,
    examDate: examDate ?? this.examDate,
    examinerNote: examinerNote.present ? examinerNote.value : this.examinerNote,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Examination copyWithCompanion(ExaminationsCompanion data) {
    return Examination(
      id: data.id.present ? data.id.value : this.id,
      patientId: data.patientId.present ? data.patientId.value : this.patientId,
      examDate: data.examDate.present ? data.examDate.value : this.examDate,
      examinerNote: data.examinerNote.present
          ? data.examinerNote.value
          : this.examinerNote,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Examination(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('examDate: $examDate, ')
          ..write('examinerNote: $examinerNote, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, patientId, examDate, examinerNote, createdAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Examination &&
          other.id == this.id &&
          other.patientId == this.patientId &&
          other.examDate == this.examDate &&
          other.examinerNote == this.examinerNote &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt);
}

class ExaminationsCompanion extends UpdateCompanion<Examination> {
  final Value<String> id;
  final Value<String> patientId;
  final Value<DateTime> examDate;
  final Value<String?> examinerNote;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const ExaminationsCompanion({
    this.id = const Value.absent(),
    this.patientId = const Value.absent(),
    this.examDate = const Value.absent(),
    this.examinerNote = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExaminationsCompanion.insert({
    this.id = const Value.absent(),
    required String patientId,
    required DateTime examDate,
    this.examinerNote = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : patientId = Value(patientId),
       examDate = Value(examDate);
  static Insertable<Examination> custom({
    Expression<String>? id,
    Expression<String>? patientId,
    Expression<DateTime>? examDate,
    Expression<String>? examinerNote,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (patientId != null) 'patient_id': patientId,
      if (examDate != null) 'exam_date': examDate,
      if (examinerNote != null) 'examiner_note': examinerNote,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExaminationsCompanion copyWith({
    Value<String>? id,
    Value<String>? patientId,
    Value<DateTime>? examDate,
    Value<String?>? examinerNote,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return ExaminationsCompanion(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      examDate: examDate ?? this.examDate,
      examinerNote: examinerNote ?? this.examinerNote,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (patientId.present) {
      map['patient_id'] = Variable<String>(patientId.value);
    }
    if (examDate.present) {
      map['exam_date'] = Variable<DateTime>(examDate.value);
    }
    if (examinerNote.present) {
      map['examiner_note'] = Variable<String>(examinerNote.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExaminationsCompanion(')
          ..write('id: $id, ')
          ..write('patientId: $patientId, ')
          ..write('examDate: $examDate, ')
          ..write('examinerNote: $examinerNote, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GrowthMeasurementsTable extends GrowthMeasurements
    with TableInfo<$GrowthMeasurementsTable, GrowthMeasurement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrowthMeasurementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => _uuid.v4(),
  );
  static const VerificationMeta _examinationIdMeta = const VerificationMeta(
    'examinationId',
  );
  @override
  late final GeneratedColumn<String> examinationId = GeneratedColumn<String>(
    'examination_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES examinations (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _headCircumferenceCmMeta =
      const VerificationMeta('headCircumferenceCm');
  @override
  late final GeneratedColumn<double> headCircumferenceCm =
      GeneratedColumn<double>(
        'head_circumference_cm',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _measuredLyingMeta = const VerificationMeta(
    'measuredLying',
  );
  @override
  late final GeneratedColumn<bool> measuredLying = GeneratedColumn<bool>(
    'measured_lying',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("measured_lying" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    examinationId,
    weightKg,
    heightCm,
    headCircumferenceCm,
    measuredLying,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'growth_measurements';
  @override
  VerificationContext validateIntegrity(
    Insertable<GrowthMeasurement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('examination_id')) {
      context.handle(
        _examinationIdMeta,
        examinationId.isAcceptableOrUnknown(
          data['examination_id']!,
          _examinationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_examinationIdMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    }
    if (data.containsKey('head_circumference_cm')) {
      context.handle(
        _headCircumferenceCmMeta,
        headCircumferenceCm.isAcceptableOrUnknown(
          data['head_circumference_cm']!,
          _headCircumferenceCmMeta,
        ),
      );
    }
    if (data.containsKey('measured_lying')) {
      context.handle(
        _measuredLyingMeta,
        measuredLying.isAcceptableOrUnknown(
          data['measured_lying']!,
          _measuredLyingMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrowthMeasurement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrowthMeasurement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      examinationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}examination_id'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      ),
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      ),
      headCircumferenceCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}head_circumference_cm'],
      ),
      measuredLying: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}measured_lying'],
      )!,
    );
  }

  @override
  $GrowthMeasurementsTable createAlias(String alias) {
    return $GrowthMeasurementsTable(attachedDatabase, alias);
  }
}

class GrowthMeasurement extends DataClass
    implements Insertable<GrowthMeasurement> {
  final String id;
  final String examinationId;
  final double? weightKg;
  final double? heightCm;
  final double? headCircumferenceCm;

  /// true bila tinggi diukur berbaring (length), false bila berdiri (height).
  final bool measuredLying;
  const GrowthMeasurement({
    required this.id,
    required this.examinationId,
    this.weightKg,
    this.heightCm,
    this.headCircumferenceCm,
    required this.measuredLying,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['examination_id'] = Variable<String>(examinationId);
    if (!nullToAbsent || weightKg != null) {
      map['weight_kg'] = Variable<double>(weightKg);
    }
    if (!nullToAbsent || heightCm != null) {
      map['height_cm'] = Variable<double>(heightCm);
    }
    if (!nullToAbsent || headCircumferenceCm != null) {
      map['head_circumference_cm'] = Variable<double>(headCircumferenceCm);
    }
    map['measured_lying'] = Variable<bool>(measuredLying);
    return map;
  }

  GrowthMeasurementsCompanion toCompanion(bool nullToAbsent) {
    return GrowthMeasurementsCompanion(
      id: Value(id),
      examinationId: Value(examinationId),
      weightKg: weightKg == null && nullToAbsent
          ? const Value.absent()
          : Value(weightKg),
      heightCm: heightCm == null && nullToAbsent
          ? const Value.absent()
          : Value(heightCm),
      headCircumferenceCm: headCircumferenceCm == null && nullToAbsent
          ? const Value.absent()
          : Value(headCircumferenceCm),
      measuredLying: Value(measuredLying),
    );
  }

  factory GrowthMeasurement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrowthMeasurement(
      id: serializer.fromJson<String>(json['id']),
      examinationId: serializer.fromJson<String>(json['examinationId']),
      weightKg: serializer.fromJson<double?>(json['weightKg']),
      heightCm: serializer.fromJson<double?>(json['heightCm']),
      headCircumferenceCm: serializer.fromJson<double?>(
        json['headCircumferenceCm'],
      ),
      measuredLying: serializer.fromJson<bool>(json['measuredLying']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'examinationId': serializer.toJson<String>(examinationId),
      'weightKg': serializer.toJson<double?>(weightKg),
      'heightCm': serializer.toJson<double?>(heightCm),
      'headCircumferenceCm': serializer.toJson<double?>(headCircumferenceCm),
      'measuredLying': serializer.toJson<bool>(measuredLying),
    };
  }

  GrowthMeasurement copyWith({
    String? id,
    String? examinationId,
    Value<double?> weightKg = const Value.absent(),
    Value<double?> heightCm = const Value.absent(),
    Value<double?> headCircumferenceCm = const Value.absent(),
    bool? measuredLying,
  }) => GrowthMeasurement(
    id: id ?? this.id,
    examinationId: examinationId ?? this.examinationId,
    weightKg: weightKg.present ? weightKg.value : this.weightKg,
    heightCm: heightCm.present ? heightCm.value : this.heightCm,
    headCircumferenceCm: headCircumferenceCm.present
        ? headCircumferenceCm.value
        : this.headCircumferenceCm,
    measuredLying: measuredLying ?? this.measuredLying,
  );
  GrowthMeasurement copyWithCompanion(GrowthMeasurementsCompanion data) {
    return GrowthMeasurement(
      id: data.id.present ? data.id.value : this.id,
      examinationId: data.examinationId.present
          ? data.examinationId.value
          : this.examinationId,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      headCircumferenceCm: data.headCircumferenceCm.present
          ? data.headCircumferenceCm.value
          : this.headCircumferenceCm,
      measuredLying: data.measuredLying.present
          ? data.measuredLying.value
          : this.measuredLying,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrowthMeasurement(')
          ..write('id: $id, ')
          ..write('examinationId: $examinationId, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('headCircumferenceCm: $headCircumferenceCm, ')
          ..write('measuredLying: $measuredLying')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    examinationId,
    weightKg,
    heightCm,
    headCircumferenceCm,
    measuredLying,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrowthMeasurement &&
          other.id == this.id &&
          other.examinationId == this.examinationId &&
          other.weightKg == this.weightKg &&
          other.heightCm == this.heightCm &&
          other.headCircumferenceCm == this.headCircumferenceCm &&
          other.measuredLying == this.measuredLying);
}

class GrowthMeasurementsCompanion extends UpdateCompanion<GrowthMeasurement> {
  final Value<String> id;
  final Value<String> examinationId;
  final Value<double?> weightKg;
  final Value<double?> heightCm;
  final Value<double?> headCircumferenceCm;
  final Value<bool> measuredLying;
  final Value<int> rowid;
  const GrowthMeasurementsCompanion({
    this.id = const Value.absent(),
    this.examinationId = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.headCircumferenceCm = const Value.absent(),
    this.measuredLying = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GrowthMeasurementsCompanion.insert({
    this.id = const Value.absent(),
    required String examinationId,
    this.weightKg = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.headCircumferenceCm = const Value.absent(),
    this.measuredLying = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : examinationId = Value(examinationId);
  static Insertable<GrowthMeasurement> custom({
    Expression<String>? id,
    Expression<String>? examinationId,
    Expression<double>? weightKg,
    Expression<double>? heightCm,
    Expression<double>? headCircumferenceCm,
    Expression<bool>? measuredLying,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (examinationId != null) 'examination_id': examinationId,
      if (weightKg != null) 'weight_kg': weightKg,
      if (heightCm != null) 'height_cm': heightCm,
      if (headCircumferenceCm != null)
        'head_circumference_cm': headCircumferenceCm,
      if (measuredLying != null) 'measured_lying': measuredLying,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GrowthMeasurementsCompanion copyWith({
    Value<String>? id,
    Value<String>? examinationId,
    Value<double?>? weightKg,
    Value<double?>? heightCm,
    Value<double?>? headCircumferenceCm,
    Value<bool>? measuredLying,
    Value<int>? rowid,
  }) {
    return GrowthMeasurementsCompanion(
      id: id ?? this.id,
      examinationId: examinationId ?? this.examinationId,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      headCircumferenceCm: headCircumferenceCm ?? this.headCircumferenceCm,
      measuredLying: measuredLying ?? this.measuredLying,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (examinationId.present) {
      map['examination_id'] = Variable<String>(examinationId.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (headCircumferenceCm.present) {
      map['head_circumference_cm'] = Variable<double>(
        headCircumferenceCm.value,
      );
    }
    if (measuredLying.present) {
      map['measured_lying'] = Variable<bool>(measuredLying.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrowthMeasurementsCompanion(')
          ..write('id: $id, ')
          ..write('examinationId: $examinationId, ')
          ..write('weightKg: $weightKg, ')
          ..write('heightCm: $heightCm, ')
          ..write('headCircumferenceCm: $headCircumferenceCm, ')
          ..write('measuredLying: $measuredLying, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KpspResultsTable extends KpspResults
    with TableInfo<$KpspResultsTable, KpspResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KpspResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => _uuid.v4(),
  );
  static const VerificationMeta _examinationIdMeta = const VerificationMeta(
    'examinationId',
  );
  @override
  late final GeneratedColumn<String> examinationId = GeneratedColumn<String>(
    'examination_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES examinations (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _formAgeMonthsMeta = const VerificationMeta(
    'formAgeMonths',
  );
  @override
  late final GeneratedColumn<int> formAgeMonths = GeneratedColumn<int>(
    'form_age_months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yesCountMeta = const VerificationMeta(
    'yesCount',
  );
  @override
  late final GeneratedColumn<int> yesCount = GeneratedColumn<int>(
    'yes_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalQuestionsMeta = const VerificationMeta(
    'totalQuestions',
  );
  @override
  late final GeneratedColumn<int> totalQuestions = GeneratedColumn<int>(
    'total_questions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _resultMeta = const VerificationMeta('result');
  @override
  late final GeneratedColumn<String> result = GeneratedColumn<String>(
    'result',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answersJsonMeta = const VerificationMeta(
    'answersJson',
  );
  @override
  late final GeneratedColumn<String> answersJson = GeneratedColumn<String>(
    'answers_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    examinationId,
    formAgeMonths,
    yesCount,
    totalQuestions,
    result,
    answersJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kpsp_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<KpspResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('examination_id')) {
      context.handle(
        _examinationIdMeta,
        examinationId.isAcceptableOrUnknown(
          data['examination_id']!,
          _examinationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_examinationIdMeta);
    }
    if (data.containsKey('form_age_months')) {
      context.handle(
        _formAgeMonthsMeta,
        formAgeMonths.isAcceptableOrUnknown(
          data['form_age_months']!,
          _formAgeMonthsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_formAgeMonthsMeta);
    }
    if (data.containsKey('yes_count')) {
      context.handle(
        _yesCountMeta,
        yesCount.isAcceptableOrUnknown(data['yes_count']!, _yesCountMeta),
      );
    } else if (isInserting) {
      context.missing(_yesCountMeta);
    }
    if (data.containsKey('total_questions')) {
      context.handle(
        _totalQuestionsMeta,
        totalQuestions.isAcceptableOrUnknown(
          data['total_questions']!,
          _totalQuestionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalQuestionsMeta);
    }
    if (data.containsKey('result')) {
      context.handle(
        _resultMeta,
        result.isAcceptableOrUnknown(data['result']!, _resultMeta),
      );
    } else if (isInserting) {
      context.missing(_resultMeta);
    }
    if (data.containsKey('answers_json')) {
      context.handle(
        _answersJsonMeta,
        answersJson.isAcceptableOrUnknown(
          data['answers_json']!,
          _answersJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_answersJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KpspResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KpspResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      examinationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}examination_id'],
      )!,
      formAgeMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}form_age_months'],
      )!,
      yesCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}yes_count'],
      )!,
      totalQuestions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_questions'],
      )!,
      result: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result'],
      )!,
      answersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answers_json'],
      )!,
    );
  }

  @override
  $KpspResultsTable createAlias(String alias) {
    return $KpspResultsTable(attachedDatabase, alias);
  }
}

class KpspResult extends DataClass implements Insertable<KpspResult> {
  final String id;
  final String examinationId;

  /// Form usia yang dipakai (bulan): 3,6,9,...,72.
  final int formAgeMonths;

  /// Jumlah jawaban "Ya".
  final int yesCount;
  final int totalQuestions;

  /// Hasil: 'sesuai' | 'meragukan' | 'penyimpangan'.
  final String result;

  /// JSON map jawaban per nomor pertanyaan (untuk audit & analisis domain).
  final String answersJson;
  const KpspResult({
    required this.id,
    required this.examinationId,
    required this.formAgeMonths,
    required this.yesCount,
    required this.totalQuestions,
    required this.result,
    required this.answersJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['examination_id'] = Variable<String>(examinationId);
    map['form_age_months'] = Variable<int>(formAgeMonths);
    map['yes_count'] = Variable<int>(yesCount);
    map['total_questions'] = Variable<int>(totalQuestions);
    map['result'] = Variable<String>(result);
    map['answers_json'] = Variable<String>(answersJson);
    return map;
  }

  KpspResultsCompanion toCompanion(bool nullToAbsent) {
    return KpspResultsCompanion(
      id: Value(id),
      examinationId: Value(examinationId),
      formAgeMonths: Value(formAgeMonths),
      yesCount: Value(yesCount),
      totalQuestions: Value(totalQuestions),
      result: Value(result),
      answersJson: Value(answersJson),
    );
  }

  factory KpspResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KpspResult(
      id: serializer.fromJson<String>(json['id']),
      examinationId: serializer.fromJson<String>(json['examinationId']),
      formAgeMonths: serializer.fromJson<int>(json['formAgeMonths']),
      yesCount: serializer.fromJson<int>(json['yesCount']),
      totalQuestions: serializer.fromJson<int>(json['totalQuestions']),
      result: serializer.fromJson<String>(json['result']),
      answersJson: serializer.fromJson<String>(json['answersJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'examinationId': serializer.toJson<String>(examinationId),
      'formAgeMonths': serializer.toJson<int>(formAgeMonths),
      'yesCount': serializer.toJson<int>(yesCount),
      'totalQuestions': serializer.toJson<int>(totalQuestions),
      'result': serializer.toJson<String>(result),
      'answersJson': serializer.toJson<String>(answersJson),
    };
  }

  KpspResult copyWith({
    String? id,
    String? examinationId,
    int? formAgeMonths,
    int? yesCount,
    int? totalQuestions,
    String? result,
    String? answersJson,
  }) => KpspResult(
    id: id ?? this.id,
    examinationId: examinationId ?? this.examinationId,
    formAgeMonths: formAgeMonths ?? this.formAgeMonths,
    yesCount: yesCount ?? this.yesCount,
    totalQuestions: totalQuestions ?? this.totalQuestions,
    result: result ?? this.result,
    answersJson: answersJson ?? this.answersJson,
  );
  KpspResult copyWithCompanion(KpspResultsCompanion data) {
    return KpspResult(
      id: data.id.present ? data.id.value : this.id,
      examinationId: data.examinationId.present
          ? data.examinationId.value
          : this.examinationId,
      formAgeMonths: data.formAgeMonths.present
          ? data.formAgeMonths.value
          : this.formAgeMonths,
      yesCount: data.yesCount.present ? data.yesCount.value : this.yesCount,
      totalQuestions: data.totalQuestions.present
          ? data.totalQuestions.value
          : this.totalQuestions,
      result: data.result.present ? data.result.value : this.result,
      answersJson: data.answersJson.present
          ? data.answersJson.value
          : this.answersJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KpspResult(')
          ..write('id: $id, ')
          ..write('examinationId: $examinationId, ')
          ..write('formAgeMonths: $formAgeMonths, ')
          ..write('yesCount: $yesCount, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('result: $result, ')
          ..write('answersJson: $answersJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    examinationId,
    formAgeMonths,
    yesCount,
    totalQuestions,
    result,
    answersJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KpspResult &&
          other.id == this.id &&
          other.examinationId == this.examinationId &&
          other.formAgeMonths == this.formAgeMonths &&
          other.yesCount == this.yesCount &&
          other.totalQuestions == this.totalQuestions &&
          other.result == this.result &&
          other.answersJson == this.answersJson);
}

class KpspResultsCompanion extends UpdateCompanion<KpspResult> {
  final Value<String> id;
  final Value<String> examinationId;
  final Value<int> formAgeMonths;
  final Value<int> yesCount;
  final Value<int> totalQuestions;
  final Value<String> result;
  final Value<String> answersJson;
  final Value<int> rowid;
  const KpspResultsCompanion({
    this.id = const Value.absent(),
    this.examinationId = const Value.absent(),
    this.formAgeMonths = const Value.absent(),
    this.yesCount = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.result = const Value.absent(),
    this.answersJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KpspResultsCompanion.insert({
    this.id = const Value.absent(),
    required String examinationId,
    required int formAgeMonths,
    required int yesCount,
    required int totalQuestions,
    required String result,
    required String answersJson,
    this.rowid = const Value.absent(),
  }) : examinationId = Value(examinationId),
       formAgeMonths = Value(formAgeMonths),
       yesCount = Value(yesCount),
       totalQuestions = Value(totalQuestions),
       result = Value(result),
       answersJson = Value(answersJson);
  static Insertable<KpspResult> custom({
    Expression<String>? id,
    Expression<String>? examinationId,
    Expression<int>? formAgeMonths,
    Expression<int>? yesCount,
    Expression<int>? totalQuestions,
    Expression<String>? result,
    Expression<String>? answersJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (examinationId != null) 'examination_id': examinationId,
      if (formAgeMonths != null) 'form_age_months': formAgeMonths,
      if (yesCount != null) 'yes_count': yesCount,
      if (totalQuestions != null) 'total_questions': totalQuestions,
      if (result != null) 'result': result,
      if (answersJson != null) 'answers_json': answersJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KpspResultsCompanion copyWith({
    Value<String>? id,
    Value<String>? examinationId,
    Value<int>? formAgeMonths,
    Value<int>? yesCount,
    Value<int>? totalQuestions,
    Value<String>? result,
    Value<String>? answersJson,
    Value<int>? rowid,
  }) {
    return KpspResultsCompanion(
      id: id ?? this.id,
      examinationId: examinationId ?? this.examinationId,
      formAgeMonths: formAgeMonths ?? this.formAgeMonths,
      yesCount: yesCount ?? this.yesCount,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      result: result ?? this.result,
      answersJson: answersJson ?? this.answersJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (examinationId.present) {
      map['examination_id'] = Variable<String>(examinationId.value);
    }
    if (formAgeMonths.present) {
      map['form_age_months'] = Variable<int>(formAgeMonths.value);
    }
    if (yesCount.present) {
      map['yes_count'] = Variable<int>(yesCount.value);
    }
    if (totalQuestions.present) {
      map['total_questions'] = Variable<int>(totalQuestions.value);
    }
    if (result.present) {
      map['result'] = Variable<String>(result.value);
    }
    if (answersJson.present) {
      map['answers_json'] = Variable<String>(answersJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KpspResultsCompanion(')
          ..write('id: $id, ')
          ..write('examinationId: $examinationId, ')
          ..write('formAgeMonths: $formAgeMonths, ')
          ..write('yesCount: $yesCount, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('result: $result, ')
          ..write('answersJson: $answersJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScreeningResultsTable extends ScreeningResults
    with TableInfo<$ScreeningResultsTable, ScreeningResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScreeningResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => _uuid.v4(),
  );
  static const VerificationMeta _examinationIdMeta = const VerificationMeta(
    'examinationId',
  );
  @override
  late final GeneratedColumn<String> examinationId = GeneratedColumn<String>(
    'examination_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES examinations (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _instrumentIdMeta = const VerificationMeta(
    'instrumentId',
  );
  @override
  late final GeneratedColumn<String> instrumentId = GeneratedColumn<String>(
    'instrument_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalItemsMeta = const VerificationMeta(
    'totalItems',
  );
  @override
  late final GeneratedColumn<int> totalItems = GeneratedColumn<int>(
    'total_items',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _riskLevelMeta = const VerificationMeta(
    'riskLevel',
  );
  @override
  late final GeneratedColumn<int> riskLevel = GeneratedColumn<int>(
    'risk_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answersJsonMeta = const VerificationMeta(
    'answersJson',
  );
  @override
  late final GeneratedColumn<String> answersJson = GeneratedColumn<String>(
    'answers_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _variantLabelMeta = const VerificationMeta(
    'variantLabel',
  );
  @override
  late final GeneratedColumn<String> variantLabel = GeneratedColumn<String>(
    'variant_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    examinationId,
    instrumentId,
    score,
    totalItems,
    riskLevel,
    answersJson,
    variantLabel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'screening_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScreeningResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('examination_id')) {
      context.handle(
        _examinationIdMeta,
        examinationId.isAcceptableOrUnknown(
          data['examination_id']!,
          _examinationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_examinationIdMeta);
    }
    if (data.containsKey('instrument_id')) {
      context.handle(
        _instrumentIdMeta,
        instrumentId.isAcceptableOrUnknown(
          data['instrument_id']!,
          _instrumentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_instrumentIdMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('total_items')) {
      context.handle(
        _totalItemsMeta,
        totalItems.isAcceptableOrUnknown(data['total_items']!, _totalItemsMeta),
      );
    } else if (isInserting) {
      context.missing(_totalItemsMeta);
    }
    if (data.containsKey('risk_level')) {
      context.handle(
        _riskLevelMeta,
        riskLevel.isAcceptableOrUnknown(data['risk_level']!, _riskLevelMeta),
      );
    } else if (isInserting) {
      context.missing(_riskLevelMeta);
    }
    if (data.containsKey('answers_json')) {
      context.handle(
        _answersJsonMeta,
        answersJson.isAcceptableOrUnknown(
          data['answers_json']!,
          _answersJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_answersJsonMeta);
    }
    if (data.containsKey('variant_label')) {
      context.handle(
        _variantLabelMeta,
        variantLabel.isAcceptableOrUnknown(
          data['variant_label']!,
          _variantLabelMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScreeningResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScreeningResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      examinationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}examination_id'],
      )!,
      instrumentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instrument_id'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      totalItems: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_items'],
      )!,
      riskLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}risk_level'],
      )!,
      answersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answers_json'],
      )!,
      variantLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variant_label'],
      ),
    );
  }

  @override
  $ScreeningResultsTable createAlias(String alias) {
    return $ScreeningResultsTable(attachedDatabase, alias);
  }
}

class ScreeningResult extends DataClass implements Insertable<ScreeningResult> {
  final String id;
  final String examinationId;

  /// Kode instrumen, mis. 'kmme', 'mchat_r'.
  final String instrumentId;

  /// Skor mentah (jumlah item berisiko).
  final int score;
  final int totalItems;

  /// Tingkat risiko: 0 = rendah, 1 = sedang, 2 = tinggi.
  final int riskLevel;

  /// JSON map jawaban per nomor item.
  final String answersJson;

  /// Label varian instrumen (mis. band usia TDD "0-6 bulan"). Null bila tidak
  /// relevan. Disimpan agar laporan dapat menampilkan band yang benar.
  final String? variantLabel;
  const ScreeningResult({
    required this.id,
    required this.examinationId,
    required this.instrumentId,
    required this.score,
    required this.totalItems,
    required this.riskLevel,
    required this.answersJson,
    this.variantLabel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['examination_id'] = Variable<String>(examinationId);
    map['instrument_id'] = Variable<String>(instrumentId);
    map['score'] = Variable<int>(score);
    map['total_items'] = Variable<int>(totalItems);
    map['risk_level'] = Variable<int>(riskLevel);
    map['answers_json'] = Variable<String>(answersJson);
    if (!nullToAbsent || variantLabel != null) {
      map['variant_label'] = Variable<String>(variantLabel);
    }
    return map;
  }

  ScreeningResultsCompanion toCompanion(bool nullToAbsent) {
    return ScreeningResultsCompanion(
      id: Value(id),
      examinationId: Value(examinationId),
      instrumentId: Value(instrumentId),
      score: Value(score),
      totalItems: Value(totalItems),
      riskLevel: Value(riskLevel),
      answersJson: Value(answersJson),
      variantLabel: variantLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(variantLabel),
    );
  }

  factory ScreeningResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScreeningResult(
      id: serializer.fromJson<String>(json['id']),
      examinationId: serializer.fromJson<String>(json['examinationId']),
      instrumentId: serializer.fromJson<String>(json['instrumentId']),
      score: serializer.fromJson<int>(json['score']),
      totalItems: serializer.fromJson<int>(json['totalItems']),
      riskLevel: serializer.fromJson<int>(json['riskLevel']),
      answersJson: serializer.fromJson<String>(json['answersJson']),
      variantLabel: serializer.fromJson<String?>(json['variantLabel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'examinationId': serializer.toJson<String>(examinationId),
      'instrumentId': serializer.toJson<String>(instrumentId),
      'score': serializer.toJson<int>(score),
      'totalItems': serializer.toJson<int>(totalItems),
      'riskLevel': serializer.toJson<int>(riskLevel),
      'answersJson': serializer.toJson<String>(answersJson),
      'variantLabel': serializer.toJson<String?>(variantLabel),
    };
  }

  ScreeningResult copyWith({
    String? id,
    String? examinationId,
    String? instrumentId,
    int? score,
    int? totalItems,
    int? riskLevel,
    String? answersJson,
    Value<String?> variantLabel = const Value.absent(),
  }) => ScreeningResult(
    id: id ?? this.id,
    examinationId: examinationId ?? this.examinationId,
    instrumentId: instrumentId ?? this.instrumentId,
    score: score ?? this.score,
    totalItems: totalItems ?? this.totalItems,
    riskLevel: riskLevel ?? this.riskLevel,
    answersJson: answersJson ?? this.answersJson,
    variantLabel: variantLabel.present ? variantLabel.value : this.variantLabel,
  );
  ScreeningResult copyWithCompanion(ScreeningResultsCompanion data) {
    return ScreeningResult(
      id: data.id.present ? data.id.value : this.id,
      examinationId: data.examinationId.present
          ? data.examinationId.value
          : this.examinationId,
      instrumentId: data.instrumentId.present
          ? data.instrumentId.value
          : this.instrumentId,
      score: data.score.present ? data.score.value : this.score,
      totalItems: data.totalItems.present
          ? data.totalItems.value
          : this.totalItems,
      riskLevel: data.riskLevel.present ? data.riskLevel.value : this.riskLevel,
      answersJson: data.answersJson.present
          ? data.answersJson.value
          : this.answersJson,
      variantLabel: data.variantLabel.present
          ? data.variantLabel.value
          : this.variantLabel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScreeningResult(')
          ..write('id: $id, ')
          ..write('examinationId: $examinationId, ')
          ..write('instrumentId: $instrumentId, ')
          ..write('score: $score, ')
          ..write('totalItems: $totalItems, ')
          ..write('riskLevel: $riskLevel, ')
          ..write('answersJson: $answersJson, ')
          ..write('variantLabel: $variantLabel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    examinationId,
    instrumentId,
    score,
    totalItems,
    riskLevel,
    answersJson,
    variantLabel,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScreeningResult &&
          other.id == this.id &&
          other.examinationId == this.examinationId &&
          other.instrumentId == this.instrumentId &&
          other.score == this.score &&
          other.totalItems == this.totalItems &&
          other.riskLevel == this.riskLevel &&
          other.answersJson == this.answersJson &&
          other.variantLabel == this.variantLabel);
}

class ScreeningResultsCompanion extends UpdateCompanion<ScreeningResult> {
  final Value<String> id;
  final Value<String> examinationId;
  final Value<String> instrumentId;
  final Value<int> score;
  final Value<int> totalItems;
  final Value<int> riskLevel;
  final Value<String> answersJson;
  final Value<String?> variantLabel;
  final Value<int> rowid;
  const ScreeningResultsCompanion({
    this.id = const Value.absent(),
    this.examinationId = const Value.absent(),
    this.instrumentId = const Value.absent(),
    this.score = const Value.absent(),
    this.totalItems = const Value.absent(),
    this.riskLevel = const Value.absent(),
    this.answersJson = const Value.absent(),
    this.variantLabel = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScreeningResultsCompanion.insert({
    this.id = const Value.absent(),
    required String examinationId,
    required String instrumentId,
    required int score,
    required int totalItems,
    required int riskLevel,
    required String answersJson,
    this.variantLabel = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : examinationId = Value(examinationId),
       instrumentId = Value(instrumentId),
       score = Value(score),
       totalItems = Value(totalItems),
       riskLevel = Value(riskLevel),
       answersJson = Value(answersJson);
  static Insertable<ScreeningResult> custom({
    Expression<String>? id,
    Expression<String>? examinationId,
    Expression<String>? instrumentId,
    Expression<int>? score,
    Expression<int>? totalItems,
    Expression<int>? riskLevel,
    Expression<String>? answersJson,
    Expression<String>? variantLabel,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (examinationId != null) 'examination_id': examinationId,
      if (instrumentId != null) 'instrument_id': instrumentId,
      if (score != null) 'score': score,
      if (totalItems != null) 'total_items': totalItems,
      if (riskLevel != null) 'risk_level': riskLevel,
      if (answersJson != null) 'answers_json': answersJson,
      if (variantLabel != null) 'variant_label': variantLabel,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScreeningResultsCompanion copyWith({
    Value<String>? id,
    Value<String>? examinationId,
    Value<String>? instrumentId,
    Value<int>? score,
    Value<int>? totalItems,
    Value<int>? riskLevel,
    Value<String>? answersJson,
    Value<String?>? variantLabel,
    Value<int>? rowid,
  }) {
    return ScreeningResultsCompanion(
      id: id ?? this.id,
      examinationId: examinationId ?? this.examinationId,
      instrumentId: instrumentId ?? this.instrumentId,
      score: score ?? this.score,
      totalItems: totalItems ?? this.totalItems,
      riskLevel: riskLevel ?? this.riskLevel,
      answersJson: answersJson ?? this.answersJson,
      variantLabel: variantLabel ?? this.variantLabel,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (examinationId.present) {
      map['examination_id'] = Variable<String>(examinationId.value);
    }
    if (instrumentId.present) {
      map['instrument_id'] = Variable<String>(instrumentId.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (totalItems.present) {
      map['total_items'] = Variable<int>(totalItems.value);
    }
    if (riskLevel.present) {
      map['risk_level'] = Variable<int>(riskLevel.value);
    }
    if (answersJson.present) {
      map['answers_json'] = Variable<String>(answersJson.value);
    }
    if (variantLabel.present) {
      map['variant_label'] = Variable<String>(variantLabel.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScreeningResultsCompanion(')
          ..write('id: $id, ')
          ..write('examinationId: $examinationId, ')
          ..write('instrumentId: $instrumentId, ')
          ..write('score: $score, ')
          ..write('totalItems: $totalItems, ')
          ..write('riskLevel: $riskLevel, ')
          ..write('answersJson: $answersJson, ')
          ..write('variantLabel: $variantLabel, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VisionResultsTable extends VisionResults
    with TableInfo<$VisionResultsTable, VisionResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VisionResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => _uuid.v4(),
  );
  static const VerificationMeta _examinationIdMeta = const VerificationMeta(
    'examinationId',
  );
  @override
  late final GeneratedColumn<String> examinationId = GeneratedColumn<String>(
    'examination_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES examinations (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _rightEyeLineMeta = const VerificationMeta(
    'rightEyeLine',
  );
  @override
  late final GeneratedColumn<int> rightEyeLine = GeneratedColumn<int>(
    'right_eye_line',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _leftEyeLineMeta = const VerificationMeta(
    'leftEyeLine',
  );
  @override
  late final GeneratedColumn<int> leftEyeLine = GeneratedColumn<int>(
    'left_eye_line',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    examinationId,
    rightEyeLine,
    leftEyeLine,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'vision_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<VisionResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('examination_id')) {
      context.handle(
        _examinationIdMeta,
        examinationId.isAcceptableOrUnknown(
          data['examination_id']!,
          _examinationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_examinationIdMeta);
    }
    if (data.containsKey('right_eye_line')) {
      context.handle(
        _rightEyeLineMeta,
        rightEyeLine.isAcceptableOrUnknown(
          data['right_eye_line']!,
          _rightEyeLineMeta,
        ),
      );
    }
    if (data.containsKey('left_eye_line')) {
      context.handle(
        _leftEyeLineMeta,
        leftEyeLine.isAcceptableOrUnknown(
          data['left_eye_line']!,
          _leftEyeLineMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VisionResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VisionResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      examinationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}examination_id'],
      )!,
      rightEyeLine: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}right_eye_line'],
      ),
      leftEyeLine: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}left_eye_line'],
      ),
    );
  }

  @override
  $VisionResultsTable createAlias(String alias) {
    return $VisionResultsTable(attachedDatabase, alias);
  }
}

class VisionResult extends DataClass implements Insertable<VisionResult> {
  final String id;
  final String examinationId;

  /// Baris terkecil yang terbaca (1..4). Null bila tidak terbaca sama sekali.
  final int? rightEyeLine;
  final int? leftEyeLine;
  const VisionResult({
    required this.id,
    required this.examinationId,
    this.rightEyeLine,
    this.leftEyeLine,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['examination_id'] = Variable<String>(examinationId);
    if (!nullToAbsent || rightEyeLine != null) {
      map['right_eye_line'] = Variable<int>(rightEyeLine);
    }
    if (!nullToAbsent || leftEyeLine != null) {
      map['left_eye_line'] = Variable<int>(leftEyeLine);
    }
    return map;
  }

  VisionResultsCompanion toCompanion(bool nullToAbsent) {
    return VisionResultsCompanion(
      id: Value(id),
      examinationId: Value(examinationId),
      rightEyeLine: rightEyeLine == null && nullToAbsent
          ? const Value.absent()
          : Value(rightEyeLine),
      leftEyeLine: leftEyeLine == null && nullToAbsent
          ? const Value.absent()
          : Value(leftEyeLine),
    );
  }

  factory VisionResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VisionResult(
      id: serializer.fromJson<String>(json['id']),
      examinationId: serializer.fromJson<String>(json['examinationId']),
      rightEyeLine: serializer.fromJson<int?>(json['rightEyeLine']),
      leftEyeLine: serializer.fromJson<int?>(json['leftEyeLine']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'examinationId': serializer.toJson<String>(examinationId),
      'rightEyeLine': serializer.toJson<int?>(rightEyeLine),
      'leftEyeLine': serializer.toJson<int?>(leftEyeLine),
    };
  }

  VisionResult copyWith({
    String? id,
    String? examinationId,
    Value<int?> rightEyeLine = const Value.absent(),
    Value<int?> leftEyeLine = const Value.absent(),
  }) => VisionResult(
    id: id ?? this.id,
    examinationId: examinationId ?? this.examinationId,
    rightEyeLine: rightEyeLine.present ? rightEyeLine.value : this.rightEyeLine,
    leftEyeLine: leftEyeLine.present ? leftEyeLine.value : this.leftEyeLine,
  );
  VisionResult copyWithCompanion(VisionResultsCompanion data) {
    return VisionResult(
      id: data.id.present ? data.id.value : this.id,
      examinationId: data.examinationId.present
          ? data.examinationId.value
          : this.examinationId,
      rightEyeLine: data.rightEyeLine.present
          ? data.rightEyeLine.value
          : this.rightEyeLine,
      leftEyeLine: data.leftEyeLine.present
          ? data.leftEyeLine.value
          : this.leftEyeLine,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VisionResult(')
          ..write('id: $id, ')
          ..write('examinationId: $examinationId, ')
          ..write('rightEyeLine: $rightEyeLine, ')
          ..write('leftEyeLine: $leftEyeLine')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, examinationId, rightEyeLine, leftEyeLine);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VisionResult &&
          other.id == this.id &&
          other.examinationId == this.examinationId &&
          other.rightEyeLine == this.rightEyeLine &&
          other.leftEyeLine == this.leftEyeLine);
}

class VisionResultsCompanion extends UpdateCompanion<VisionResult> {
  final Value<String> id;
  final Value<String> examinationId;
  final Value<int?> rightEyeLine;
  final Value<int?> leftEyeLine;
  final Value<int> rowid;
  const VisionResultsCompanion({
    this.id = const Value.absent(),
    this.examinationId = const Value.absent(),
    this.rightEyeLine = const Value.absent(),
    this.leftEyeLine = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VisionResultsCompanion.insert({
    this.id = const Value.absent(),
    required String examinationId,
    this.rightEyeLine = const Value.absent(),
    this.leftEyeLine = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : examinationId = Value(examinationId);
  static Insertable<VisionResult> custom({
    Expression<String>? id,
    Expression<String>? examinationId,
    Expression<int>? rightEyeLine,
    Expression<int>? leftEyeLine,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (examinationId != null) 'examination_id': examinationId,
      if (rightEyeLine != null) 'right_eye_line': rightEyeLine,
      if (leftEyeLine != null) 'left_eye_line': leftEyeLine,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VisionResultsCompanion copyWith({
    Value<String>? id,
    Value<String>? examinationId,
    Value<int?>? rightEyeLine,
    Value<int?>? leftEyeLine,
    Value<int>? rowid,
  }) {
    return VisionResultsCompanion(
      id: id ?? this.id,
      examinationId: examinationId ?? this.examinationId,
      rightEyeLine: rightEyeLine ?? this.rightEyeLine,
      leftEyeLine: leftEyeLine ?? this.leftEyeLine,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (examinationId.present) {
      map['examination_id'] = Variable<String>(examinationId.value);
    }
    if (rightEyeLine.present) {
      map['right_eye_line'] = Variable<int>(rightEyeLine.value);
    }
    if (leftEyeLine.present) {
      map['left_eye_line'] = Variable<int>(leftEyeLine.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VisionResultsCompanion(')
          ..write('id: $id, ')
          ..write('examinationId: $examinationId, ')
          ..write('rightEyeLine: $rightEyeLine, ')
          ..write('leftEyeLine: $leftEyeLine, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CarsResultsTable extends CarsResults
    with TableInfo<$CarsResultsTable, CarsResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CarsResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => _uuid.v4(),
  );
  static const VerificationMeta _examinationIdMeta = const VerificationMeta(
    'examinationId',
  );
  @override
  late final GeneratedColumn<String> examinationId = GeneratedColumn<String>(
    'examination_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES examinations (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _totalScoreMeta = const VerificationMeta(
    'totalScore',
  );
  @override
  late final GeneratedColumn<double> totalScore = GeneratedColumn<double>(
    'total_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<int> category = GeneratedColumn<int>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answersJsonMeta = const VerificationMeta(
    'answersJson',
  );
  @override
  late final GeneratedColumn<String> answersJson = GeneratedColumn<String>(
    'answers_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    examinationId,
    totalScore,
    category,
    answersJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cars_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<CarsResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('examination_id')) {
      context.handle(
        _examinationIdMeta,
        examinationId.isAcceptableOrUnknown(
          data['examination_id']!,
          _examinationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_examinationIdMeta);
    }
    if (data.containsKey('total_score')) {
      context.handle(
        _totalScoreMeta,
        totalScore.isAcceptableOrUnknown(data['total_score']!, _totalScoreMeta),
      );
    } else if (isInserting) {
      context.missing(_totalScoreMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('answers_json')) {
      context.handle(
        _answersJsonMeta,
        answersJson.isAcceptableOrUnknown(
          data['answers_json']!,
          _answersJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_answersJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CarsResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CarsResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      examinationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}examination_id'],
      )!,
      totalScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_score'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category'],
      )!,
      answersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answers_json'],
      )!,
    );
  }

  @override
  $CarsResultsTable createAlias(String alias) {
    return $CarsResultsTable(attachedDatabase, alias);
  }
}

class CarsResult extends DataClass implements Insertable<CarsResult> {
  final String id;
  final String examinationId;

  /// Skor total (15.0 - 60.0; bisa pecahan kelipatan 0,5).
  final double totalScore;

  /// Kategori: 0 = non-autistik, 1 = ringan-sedang, 2 = berat.
  final int category;

  /// JSON map nilai per item (1..15 → double 1..4).
  final String answersJson;
  const CarsResult({
    required this.id,
    required this.examinationId,
    required this.totalScore,
    required this.category,
    required this.answersJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['examination_id'] = Variable<String>(examinationId);
    map['total_score'] = Variable<double>(totalScore);
    map['category'] = Variable<int>(category);
    map['answers_json'] = Variable<String>(answersJson);
    return map;
  }

  CarsResultsCompanion toCompanion(bool nullToAbsent) {
    return CarsResultsCompanion(
      id: Value(id),
      examinationId: Value(examinationId),
      totalScore: Value(totalScore),
      category: Value(category),
      answersJson: Value(answersJson),
    );
  }

  factory CarsResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CarsResult(
      id: serializer.fromJson<String>(json['id']),
      examinationId: serializer.fromJson<String>(json['examinationId']),
      totalScore: serializer.fromJson<double>(json['totalScore']),
      category: serializer.fromJson<int>(json['category']),
      answersJson: serializer.fromJson<String>(json['answersJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'examinationId': serializer.toJson<String>(examinationId),
      'totalScore': serializer.toJson<double>(totalScore),
      'category': serializer.toJson<int>(category),
      'answersJson': serializer.toJson<String>(answersJson),
    };
  }

  CarsResult copyWith({
    String? id,
    String? examinationId,
    double? totalScore,
    int? category,
    String? answersJson,
  }) => CarsResult(
    id: id ?? this.id,
    examinationId: examinationId ?? this.examinationId,
    totalScore: totalScore ?? this.totalScore,
    category: category ?? this.category,
    answersJson: answersJson ?? this.answersJson,
  );
  CarsResult copyWithCompanion(CarsResultsCompanion data) {
    return CarsResult(
      id: data.id.present ? data.id.value : this.id,
      examinationId: data.examinationId.present
          ? data.examinationId.value
          : this.examinationId,
      totalScore: data.totalScore.present
          ? data.totalScore.value
          : this.totalScore,
      category: data.category.present ? data.category.value : this.category,
      answersJson: data.answersJson.present
          ? data.answersJson.value
          : this.answersJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CarsResult(')
          ..write('id: $id, ')
          ..write('examinationId: $examinationId, ')
          ..write('totalScore: $totalScore, ')
          ..write('category: $category, ')
          ..write('answersJson: $answersJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, examinationId, totalScore, category, answersJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CarsResult &&
          other.id == this.id &&
          other.examinationId == this.examinationId &&
          other.totalScore == this.totalScore &&
          other.category == this.category &&
          other.answersJson == this.answersJson);
}

class CarsResultsCompanion extends UpdateCompanion<CarsResult> {
  final Value<String> id;
  final Value<String> examinationId;
  final Value<double> totalScore;
  final Value<int> category;
  final Value<String> answersJson;
  final Value<int> rowid;
  const CarsResultsCompanion({
    this.id = const Value.absent(),
    this.examinationId = const Value.absent(),
    this.totalScore = const Value.absent(),
    this.category = const Value.absent(),
    this.answersJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CarsResultsCompanion.insert({
    this.id = const Value.absent(),
    required String examinationId,
    required double totalScore,
    required int category,
    required String answersJson,
    this.rowid = const Value.absent(),
  }) : examinationId = Value(examinationId),
       totalScore = Value(totalScore),
       category = Value(category),
       answersJson = Value(answersJson);
  static Insertable<CarsResult> custom({
    Expression<String>? id,
    Expression<String>? examinationId,
    Expression<double>? totalScore,
    Expression<int>? category,
    Expression<String>? answersJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (examinationId != null) 'examination_id': examinationId,
      if (totalScore != null) 'total_score': totalScore,
      if (category != null) 'category': category,
      if (answersJson != null) 'answers_json': answersJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CarsResultsCompanion copyWith({
    Value<String>? id,
    Value<String>? examinationId,
    Value<double>? totalScore,
    Value<int>? category,
    Value<String>? answersJson,
    Value<int>? rowid,
  }) {
    return CarsResultsCompanion(
      id: id ?? this.id,
      examinationId: examinationId ?? this.examinationId,
      totalScore: totalScore ?? this.totalScore,
      category: category ?? this.category,
      answersJson: answersJson ?? this.answersJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (examinationId.present) {
      map['examination_id'] = Variable<String>(examinationId.value);
    }
    if (totalScore.present) {
      map['total_score'] = Variable<double>(totalScore.value);
    }
    if (category.present) {
      map['category'] = Variable<int>(category.value);
    }
    if (answersJson.present) {
      map['answers_json'] = Variable<String>(answersJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CarsResultsCompanion(')
          ..write('id: $id, ')
          ..write('examinationId: $examinationId, ')
          ..write('totalScore: $totalScore, ')
          ..write('category: $category, ')
          ..write('answersJson: $answersJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DenverResultsTable extends DenverResults
    with TableInfo<$DenverResultsTable, DenverResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DenverResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => _uuid.v4(),
  );
  static const VerificationMeta _examinationIdMeta = const VerificationMeta(
    'examinationId',
  );
  @override
  late final GeneratedColumn<String> examinationId = GeneratedColumn<String>(
    'examination_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES examinations (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _ageInMonthsMeta = const VerificationMeta(
    'ageInMonths',
  );
  @override
  late final GeneratedColumn<double> ageInMonths = GeneratedColumn<double>(
    'age_in_months',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usedCorrectedAgeMeta = const VerificationMeta(
    'usedCorrectedAge',
  );
  @override
  late final GeneratedColumn<bool> usedCorrectedAge = GeneratedColumn<bool>(
    'used_corrected_age',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("used_corrected_age" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _cautionsCountMeta = const VerificationMeta(
    'cautionsCount',
  );
  @override
  late final GeneratedColumn<int> cautionsCount = GeneratedColumn<int>(
    'cautions_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _delaysCountMeta = const VerificationMeta(
    'delaysCount',
  );
  @override
  late final GeneratedColumn<int> delaysCount = GeneratedColumn<int>(
    'delays_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _globalResultMeta = const VerificationMeta(
    'globalResult',
  );
  @override
  late final GeneratedColumn<String> globalResult = GeneratedColumn<String>(
    'global_result',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answersJsonMeta = const VerificationMeta(
    'answersJson',
  );
  @override
  late final GeneratedColumn<String> answersJson = GeneratedColumn<String>(
    'answers_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    examinationId,
    ageInMonths,
    usedCorrectedAge,
    cautionsCount,
    delaysCount,
    globalResult,
    answersJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'denver_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<DenverResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('examination_id')) {
      context.handle(
        _examinationIdMeta,
        examinationId.isAcceptableOrUnknown(
          data['examination_id']!,
          _examinationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_examinationIdMeta);
    }
    if (data.containsKey('age_in_months')) {
      context.handle(
        _ageInMonthsMeta,
        ageInMonths.isAcceptableOrUnknown(
          data['age_in_months']!,
          _ageInMonthsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ageInMonthsMeta);
    }
    if (data.containsKey('used_corrected_age')) {
      context.handle(
        _usedCorrectedAgeMeta,
        usedCorrectedAge.isAcceptableOrUnknown(
          data['used_corrected_age']!,
          _usedCorrectedAgeMeta,
        ),
      );
    }
    if (data.containsKey('cautions_count')) {
      context.handle(
        _cautionsCountMeta,
        cautionsCount.isAcceptableOrUnknown(
          data['cautions_count']!,
          _cautionsCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cautionsCountMeta);
    }
    if (data.containsKey('delays_count')) {
      context.handle(
        _delaysCountMeta,
        delaysCount.isAcceptableOrUnknown(
          data['delays_count']!,
          _delaysCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_delaysCountMeta);
    }
    if (data.containsKey('global_result')) {
      context.handle(
        _globalResultMeta,
        globalResult.isAcceptableOrUnknown(
          data['global_result']!,
          _globalResultMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_globalResultMeta);
    }
    if (data.containsKey('answers_json')) {
      context.handle(
        _answersJsonMeta,
        answersJson.isAcceptableOrUnknown(
          data['answers_json']!,
          _answersJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_answersJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DenverResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DenverResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      examinationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}examination_id'],
      )!,
      ageInMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}age_in_months'],
      )!,
      usedCorrectedAge: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}used_corrected_age'],
      )!,
      cautionsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cautions_count'],
      )!,
      delaysCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}delays_count'],
      )!,
      globalResult: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}global_result'],
      )!,
      answersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answers_json'],
      )!,
    );
  }

  @override
  $DenverResultsTable createAlias(String alias) {
    return $DenverResultsTable(attachedDatabase, alias);
  }
}

class DenverResult extends DataClass implements Insertable<DenverResult> {
  final String id;
  final String examinationId;
  final double ageInMonths;
  final bool usedCorrectedAge;
  final int cautionsCount;
  final int delaysCount;

  /// Hasil global: 'normal' | 'suspect' | 'untestable'.
  final String globalResult;

  /// JSON map jawaban per itemId ('P', 'F', 'R', 'NO').
  final String answersJson;
  const DenverResult({
    required this.id,
    required this.examinationId,
    required this.ageInMonths,
    required this.usedCorrectedAge,
    required this.cautionsCount,
    required this.delaysCount,
    required this.globalResult,
    required this.answersJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['examination_id'] = Variable<String>(examinationId);
    map['age_in_months'] = Variable<double>(ageInMonths);
    map['used_corrected_age'] = Variable<bool>(usedCorrectedAge);
    map['cautions_count'] = Variable<int>(cautionsCount);
    map['delays_count'] = Variable<int>(delaysCount);
    map['global_result'] = Variable<String>(globalResult);
    map['answers_json'] = Variable<String>(answersJson);
    return map;
  }

  DenverResultsCompanion toCompanion(bool nullToAbsent) {
    return DenverResultsCompanion(
      id: Value(id),
      examinationId: Value(examinationId),
      ageInMonths: Value(ageInMonths),
      usedCorrectedAge: Value(usedCorrectedAge),
      cautionsCount: Value(cautionsCount),
      delaysCount: Value(delaysCount),
      globalResult: Value(globalResult),
      answersJson: Value(answersJson),
    );
  }

  factory DenverResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DenverResult(
      id: serializer.fromJson<String>(json['id']),
      examinationId: serializer.fromJson<String>(json['examinationId']),
      ageInMonths: serializer.fromJson<double>(json['ageInMonths']),
      usedCorrectedAge: serializer.fromJson<bool>(json['usedCorrectedAge']),
      cautionsCount: serializer.fromJson<int>(json['cautionsCount']),
      delaysCount: serializer.fromJson<int>(json['delaysCount']),
      globalResult: serializer.fromJson<String>(json['globalResult']),
      answersJson: serializer.fromJson<String>(json['answersJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'examinationId': serializer.toJson<String>(examinationId),
      'ageInMonths': serializer.toJson<double>(ageInMonths),
      'usedCorrectedAge': serializer.toJson<bool>(usedCorrectedAge),
      'cautionsCount': serializer.toJson<int>(cautionsCount),
      'delaysCount': serializer.toJson<int>(delaysCount),
      'globalResult': serializer.toJson<String>(globalResult),
      'answersJson': serializer.toJson<String>(answersJson),
    };
  }

  DenverResult copyWith({
    String? id,
    String? examinationId,
    double? ageInMonths,
    bool? usedCorrectedAge,
    int? cautionsCount,
    int? delaysCount,
    String? globalResult,
    String? answersJson,
  }) => DenverResult(
    id: id ?? this.id,
    examinationId: examinationId ?? this.examinationId,
    ageInMonths: ageInMonths ?? this.ageInMonths,
    usedCorrectedAge: usedCorrectedAge ?? this.usedCorrectedAge,
    cautionsCount: cautionsCount ?? this.cautionsCount,
    delaysCount: delaysCount ?? this.delaysCount,
    globalResult: globalResult ?? this.globalResult,
    answersJson: answersJson ?? this.answersJson,
  );
  DenverResult copyWithCompanion(DenverResultsCompanion data) {
    return DenverResult(
      id: data.id.present ? data.id.value : this.id,
      examinationId: data.examinationId.present
          ? data.examinationId.value
          : this.examinationId,
      ageInMonths: data.ageInMonths.present
          ? data.ageInMonths.value
          : this.ageInMonths,
      usedCorrectedAge: data.usedCorrectedAge.present
          ? data.usedCorrectedAge.value
          : this.usedCorrectedAge,
      cautionsCount: data.cautionsCount.present
          ? data.cautionsCount.value
          : this.cautionsCount,
      delaysCount: data.delaysCount.present
          ? data.delaysCount.value
          : this.delaysCount,
      globalResult: data.globalResult.present
          ? data.globalResult.value
          : this.globalResult,
      answersJson: data.answersJson.present
          ? data.answersJson.value
          : this.answersJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DenverResult(')
          ..write('id: $id, ')
          ..write('examinationId: $examinationId, ')
          ..write('ageInMonths: $ageInMonths, ')
          ..write('usedCorrectedAge: $usedCorrectedAge, ')
          ..write('cautionsCount: $cautionsCount, ')
          ..write('delaysCount: $delaysCount, ')
          ..write('globalResult: $globalResult, ')
          ..write('answersJson: $answersJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    examinationId,
    ageInMonths,
    usedCorrectedAge,
    cautionsCount,
    delaysCount,
    globalResult,
    answersJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DenverResult &&
          other.id == this.id &&
          other.examinationId == this.examinationId &&
          other.ageInMonths == this.ageInMonths &&
          other.usedCorrectedAge == this.usedCorrectedAge &&
          other.cautionsCount == this.cautionsCount &&
          other.delaysCount == this.delaysCount &&
          other.globalResult == this.globalResult &&
          other.answersJson == this.answersJson);
}

class DenverResultsCompanion extends UpdateCompanion<DenverResult> {
  final Value<String> id;
  final Value<String> examinationId;
  final Value<double> ageInMonths;
  final Value<bool> usedCorrectedAge;
  final Value<int> cautionsCount;
  final Value<int> delaysCount;
  final Value<String> globalResult;
  final Value<String> answersJson;
  final Value<int> rowid;
  const DenverResultsCompanion({
    this.id = const Value.absent(),
    this.examinationId = const Value.absent(),
    this.ageInMonths = const Value.absent(),
    this.usedCorrectedAge = const Value.absent(),
    this.cautionsCount = const Value.absent(),
    this.delaysCount = const Value.absent(),
    this.globalResult = const Value.absent(),
    this.answersJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DenverResultsCompanion.insert({
    this.id = const Value.absent(),
    required String examinationId,
    required double ageInMonths,
    this.usedCorrectedAge = const Value.absent(),
    required int cautionsCount,
    required int delaysCount,
    required String globalResult,
    required String answersJson,
    this.rowid = const Value.absent(),
  }) : examinationId = Value(examinationId),
       ageInMonths = Value(ageInMonths),
       cautionsCount = Value(cautionsCount),
       delaysCount = Value(delaysCount),
       globalResult = Value(globalResult),
       answersJson = Value(answersJson);
  static Insertable<DenverResult> custom({
    Expression<String>? id,
    Expression<String>? examinationId,
    Expression<double>? ageInMonths,
    Expression<bool>? usedCorrectedAge,
    Expression<int>? cautionsCount,
    Expression<int>? delaysCount,
    Expression<String>? globalResult,
    Expression<String>? answersJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (examinationId != null) 'examination_id': examinationId,
      if (ageInMonths != null) 'age_in_months': ageInMonths,
      if (usedCorrectedAge != null) 'used_corrected_age': usedCorrectedAge,
      if (cautionsCount != null) 'cautions_count': cautionsCount,
      if (delaysCount != null) 'delays_count': delaysCount,
      if (globalResult != null) 'global_result': globalResult,
      if (answersJson != null) 'answers_json': answersJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DenverResultsCompanion copyWith({
    Value<String>? id,
    Value<String>? examinationId,
    Value<double>? ageInMonths,
    Value<bool>? usedCorrectedAge,
    Value<int>? cautionsCount,
    Value<int>? delaysCount,
    Value<String>? globalResult,
    Value<String>? answersJson,
    Value<int>? rowid,
  }) {
    return DenverResultsCompanion(
      id: id ?? this.id,
      examinationId: examinationId ?? this.examinationId,
      ageInMonths: ageInMonths ?? this.ageInMonths,
      usedCorrectedAge: usedCorrectedAge ?? this.usedCorrectedAge,
      cautionsCount: cautionsCount ?? this.cautionsCount,
      delaysCount: delaysCount ?? this.delaysCount,
      globalResult: globalResult ?? this.globalResult,
      answersJson: answersJson ?? this.answersJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (examinationId.present) {
      map['examination_id'] = Variable<String>(examinationId.value);
    }
    if (ageInMonths.present) {
      map['age_in_months'] = Variable<double>(ageInMonths.value);
    }
    if (usedCorrectedAge.present) {
      map['used_corrected_age'] = Variable<bool>(usedCorrectedAge.value);
    }
    if (cautionsCount.present) {
      map['cautions_count'] = Variable<int>(cautionsCount.value);
    }
    if (delaysCount.present) {
      map['delays_count'] = Variable<int>(delaysCount.value);
    }
    if (globalResult.present) {
      map['global_result'] = Variable<String>(globalResult.value);
    }
    if (answersJson.present) {
      map['answers_json'] = Variable<String>(answersJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DenverResultsCompanion(')
          ..write('id: $id, ')
          ..write('examinationId: $examinationId, ')
          ..write('ageInMonths: $ageInMonths, ')
          ..write('usedCorrectedAge: $usedCorrectedAge, ')
          ..write('cautionsCount: $cautionsCount, ')
          ..write('delaysCount: $delaysCount, ')
          ..write('globalResult: $globalResult, ')
          ..write('answersJson: $answersJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PatientsTable patients = $PatientsTable(this);
  late final $ExaminationsTable examinations = $ExaminationsTable(this);
  late final $GrowthMeasurementsTable growthMeasurements =
      $GrowthMeasurementsTable(this);
  late final $KpspResultsTable kpspResults = $KpspResultsTable(this);
  late final $ScreeningResultsTable screeningResults = $ScreeningResultsTable(
    this,
  );
  late final $VisionResultsTable visionResults = $VisionResultsTable(this);
  late final $CarsResultsTable carsResults = $CarsResultsTable(this);
  late final $DenverResultsTable denverResults = $DenverResultsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    patients,
    examinations,
    growthMeasurements,
    kpspResults,
    screeningResults,
    visionResults,
    carsResults,
    denverResults,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'patients',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('examinations', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'examinations',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('growth_measurements', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'examinations',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('kpsp_results', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'examinations',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('screening_results', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'examinations',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('vision_results', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'examinations',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('cars_results', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'examinations',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('denver_results', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$PatientsTableCreateCompanionBuilder =
    PatientsCompanion Function({
      Value<String> id,
      required String name,
      Value<String?> medicalRecordNo,
      required DateTime birthDate,
      required String sex,
      Value<String?> parentName,
      Value<String?> phone,
      Value<String?> address,
      Value<int?> gestationalWeeks,
      Value<bool> isPremature,
      Value<bool> hasDownSyndrome,
      Value<double?> fatherHeightCm,
      Value<double?> motherHeightCm,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$PatientsTableUpdateCompanionBuilder =
    PatientsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> medicalRecordNo,
      Value<DateTime> birthDate,
      Value<String> sex,
      Value<String?> parentName,
      Value<String?> phone,
      Value<String?> address,
      Value<int?> gestationalWeeks,
      Value<bool> isPremature,
      Value<bool> hasDownSyndrome,
      Value<double?> fatherHeightCm,
      Value<double?> motherHeightCm,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$PatientsTableReferences
    extends BaseReferences<_$AppDatabase, $PatientsTable, Patient> {
  $$PatientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExaminationsTable, List<Examination>>
  _examinationsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.examinations,
    aliasName: $_aliasNameGenerator(db.patients.id, db.examinations.patientId),
  );

  $$ExaminationsTableProcessedTableManager get examinationsRefs {
    final manager = $$ExaminationsTableTableManager(
      $_db,
      $_db.examinations,
    ).filter((f) => f.patientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_examinationsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PatientsTableFilterComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get medicalRecordNo => $composableBuilder(
    column: $table.medicalRecordNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentName => $composableBuilder(
    column: $table.parentName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gestationalWeeks => $composableBuilder(
    column: $table.gestationalWeeks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPremature => $composableBuilder(
    column: $table.isPremature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasDownSyndrome => $composableBuilder(
    column: $table.hasDownSyndrome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatherHeightCm => $composableBuilder(
    column: $table.fatherHeightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get motherHeightCm => $composableBuilder(
    column: $table.motherHeightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> examinationsRefs(
    Expression<bool> Function($$ExaminationsTableFilterComposer f) f,
  ) {
    final $$ExaminationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.patientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableFilterComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PatientsTableOrderingComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get medicalRecordNo => $composableBuilder(
    column: $table.medicalRecordNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentName => $composableBuilder(
    column: $table.parentName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gestationalWeeks => $composableBuilder(
    column: $table.gestationalWeeks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPremature => $composableBuilder(
    column: $table.isPremature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasDownSyndrome => $composableBuilder(
    column: $table.hasDownSyndrome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatherHeightCm => $composableBuilder(
    column: $table.fatherHeightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get motherHeightCm => $composableBuilder(
    column: $table.motherHeightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PatientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PatientsTable> {
  $$PatientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get medicalRecordNo => $composableBuilder(
    column: $table.medicalRecordNo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<String> get parentName => $composableBuilder(
    column: $table.parentName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<int> get gestationalWeeks => $composableBuilder(
    column: $table.gestationalWeeks,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPremature => $composableBuilder(
    column: $table.isPremature,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasDownSyndrome => $composableBuilder(
    column: $table.hasDownSyndrome,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatherHeightCm => $composableBuilder(
    column: $table.fatherHeightCm,
    builder: (column) => column,
  );

  GeneratedColumn<double> get motherHeightCm => $composableBuilder(
    column: $table.motherHeightCm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> examinationsRefs<T extends Object>(
    Expression<T> Function($$ExaminationsTableAnnotationComposer a) f,
  ) {
    final $$ExaminationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.patientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableAnnotationComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PatientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PatientsTable,
          Patient,
          $$PatientsTableFilterComposer,
          $$PatientsTableOrderingComposer,
          $$PatientsTableAnnotationComposer,
          $$PatientsTableCreateCompanionBuilder,
          $$PatientsTableUpdateCompanionBuilder,
          (Patient, $$PatientsTableReferences),
          Patient,
          PrefetchHooks Function({bool examinationsRefs})
        > {
  $$PatientsTableTableManager(_$AppDatabase db, $PatientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PatientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PatientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PatientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> medicalRecordNo = const Value.absent(),
                Value<DateTime> birthDate = const Value.absent(),
                Value<String> sex = const Value.absent(),
                Value<String?> parentName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<int?> gestationalWeeks = const Value.absent(),
                Value<bool> isPremature = const Value.absent(),
                Value<bool> hasDownSyndrome = const Value.absent(),
                Value<double?> fatherHeightCm = const Value.absent(),
                Value<double?> motherHeightCm = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatientsCompanion(
                id: id,
                name: name,
                medicalRecordNo: medicalRecordNo,
                birthDate: birthDate,
                sex: sex,
                parentName: parentName,
                phone: phone,
                address: address,
                gestationalWeeks: gestationalWeeks,
                isPremature: isPremature,
                hasDownSyndrome: hasDownSyndrome,
                fatherHeightCm: fatherHeightCm,
                motherHeightCm: motherHeightCm,
                notes: notes,
                createdAt: createdAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String name,
                Value<String?> medicalRecordNo = const Value.absent(),
                required DateTime birthDate,
                required String sex,
                Value<String?> parentName = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<int?> gestationalWeeks = const Value.absent(),
                Value<bool> isPremature = const Value.absent(),
                Value<bool> hasDownSyndrome = const Value.absent(),
                Value<double?> fatherHeightCm = const Value.absent(),
                Value<double?> motherHeightCm = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PatientsCompanion.insert(
                id: id,
                name: name,
                medicalRecordNo: medicalRecordNo,
                birthDate: birthDate,
                sex: sex,
                parentName: parentName,
                phone: phone,
                address: address,
                gestationalWeeks: gestationalWeeks,
                isPremature: isPremature,
                hasDownSyndrome: hasDownSyndrome,
                fatherHeightCm: fatherHeightCm,
                motherHeightCm: motherHeightCm,
                notes: notes,
                createdAt: createdAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PatientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({examinationsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (examinationsRefs) db.examinations],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (examinationsRefs)
                    await $_getPrefetchedData<
                      Patient,
                      $PatientsTable,
                      Examination
                    >(
                      currentTable: table,
                      referencedTable: $$PatientsTableReferences
                          ._examinationsRefsTable(db),
                      managerFromTypedResult: (p0) => $$PatientsTableReferences(
                        db,
                        table,
                        p0,
                      ).examinationsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.patientId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PatientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PatientsTable,
      Patient,
      $$PatientsTableFilterComposer,
      $$PatientsTableOrderingComposer,
      $$PatientsTableAnnotationComposer,
      $$PatientsTableCreateCompanionBuilder,
      $$PatientsTableUpdateCompanionBuilder,
      (Patient, $$PatientsTableReferences),
      Patient,
      PrefetchHooks Function({bool examinationsRefs})
    >;
typedef $$ExaminationsTableCreateCompanionBuilder =
    ExaminationsCompanion Function({
      Value<String> id,
      required String patientId,
      required DateTime examDate,
      Value<String?> examinerNote,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$ExaminationsTableUpdateCompanionBuilder =
    ExaminationsCompanion Function({
      Value<String> id,
      Value<String> patientId,
      Value<DateTime> examDate,
      Value<String?> examinerNote,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

final class $$ExaminationsTableReferences
    extends BaseReferences<_$AppDatabase, $ExaminationsTable, Examination> {
  $$ExaminationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PatientsTable _patientIdTable(_$AppDatabase db) =>
      db.patients.createAlias(
        $_aliasNameGenerator(db.examinations.patientId, db.patients.id),
      );

  $$PatientsTableProcessedTableManager get patientId {
    final $_column = $_itemColumn<String>('patient_id')!;

    final manager = $$PatientsTableTableManager(
      $_db,
      $_db.patients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_patientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$GrowthMeasurementsTable, List<GrowthMeasurement>>
  _growthMeasurementsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.growthMeasurements,
        aliasName: $_aliasNameGenerator(
          db.examinations.id,
          db.growthMeasurements.examinationId,
        ),
      );

  $$GrowthMeasurementsTableProcessedTableManager get growthMeasurementsRefs {
    final manager = $$GrowthMeasurementsTableTableManager(
      $_db,
      $_db.growthMeasurements,
    ).filter((f) => f.examinationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _growthMeasurementsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$KpspResultsTable, List<KpspResult>>
  _kpspResultsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.kpspResults,
    aliasName: $_aliasNameGenerator(
      db.examinations.id,
      db.kpspResults.examinationId,
    ),
  );

  $$KpspResultsTableProcessedTableManager get kpspResultsRefs {
    final manager = $$KpspResultsTableTableManager(
      $_db,
      $_db.kpspResults,
    ).filter((f) => f.examinationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_kpspResultsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ScreeningResultsTable, List<ScreeningResult>>
  _screeningResultsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.screeningResults,
    aliasName: $_aliasNameGenerator(
      db.examinations.id,
      db.screeningResults.examinationId,
    ),
  );

  $$ScreeningResultsTableProcessedTableManager get screeningResultsRefs {
    final manager = $$ScreeningResultsTableTableManager(
      $_db,
      $_db.screeningResults,
    ).filter((f) => f.examinationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _screeningResultsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$VisionResultsTable, List<VisionResult>>
  _visionResultsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.visionResults,
    aliasName: $_aliasNameGenerator(
      db.examinations.id,
      db.visionResults.examinationId,
    ),
  );

  $$VisionResultsTableProcessedTableManager get visionResultsRefs {
    final manager = $$VisionResultsTableTableManager(
      $_db,
      $_db.visionResults,
    ).filter((f) => f.examinationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_visionResultsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CarsResultsTable, List<CarsResult>>
  _carsResultsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.carsResults,
    aliasName: $_aliasNameGenerator(
      db.examinations.id,
      db.carsResults.examinationId,
    ),
  );

  $$CarsResultsTableProcessedTableManager get carsResultsRefs {
    final manager = $$CarsResultsTableTableManager(
      $_db,
      $_db.carsResults,
    ).filter((f) => f.examinationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_carsResultsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DenverResultsTable, List<DenverResult>>
  _denverResultsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.denverResults,
    aliasName: $_aliasNameGenerator(
      db.examinations.id,
      db.denverResults.examinationId,
    ),
  );

  $$DenverResultsTableProcessedTableManager get denverResultsRefs {
    final manager = $$DenverResultsTableTableManager(
      $_db,
      $_db.denverResults,
    ).filter((f) => f.examinationId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_denverResultsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExaminationsTableFilterComposer
    extends Composer<_$AppDatabase, $ExaminationsTable> {
  $$ExaminationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get examDate => $composableBuilder(
    column: $table.examDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get examinerNote => $composableBuilder(
    column: $table.examinerNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PatientsTableFilterComposer get patientId {
    final $$PatientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableFilterComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> growthMeasurementsRefs(
    Expression<bool> Function($$GrowthMeasurementsTableFilterComposer f) f,
  ) {
    final $$GrowthMeasurementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.growthMeasurements,
      getReferencedColumn: (t) => t.examinationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GrowthMeasurementsTableFilterComposer(
            $db: $db,
            $table: $db.growthMeasurements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> kpspResultsRefs(
    Expression<bool> Function($$KpspResultsTableFilterComposer f) f,
  ) {
    final $$KpspResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kpspResults,
      getReferencedColumn: (t) => t.examinationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KpspResultsTableFilterComposer(
            $db: $db,
            $table: $db.kpspResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> screeningResultsRefs(
    Expression<bool> Function($$ScreeningResultsTableFilterComposer f) f,
  ) {
    final $$ScreeningResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.screeningResults,
      getReferencedColumn: (t) => t.examinationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScreeningResultsTableFilterComposer(
            $db: $db,
            $table: $db.screeningResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> visionResultsRefs(
    Expression<bool> Function($$VisionResultsTableFilterComposer f) f,
  ) {
    final $$VisionResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visionResults,
      getReferencedColumn: (t) => t.examinationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisionResultsTableFilterComposer(
            $db: $db,
            $table: $db.visionResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> carsResultsRefs(
    Expression<bool> Function($$CarsResultsTableFilterComposer f) f,
  ) {
    final $$CarsResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.carsResults,
      getReferencedColumn: (t) => t.examinationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarsResultsTableFilterComposer(
            $db: $db,
            $table: $db.carsResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> denverResultsRefs(
    Expression<bool> Function($$DenverResultsTableFilterComposer f) f,
  ) {
    final $$DenverResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.denverResults,
      getReferencedColumn: (t) => t.examinationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DenverResultsTableFilterComposer(
            $db: $db,
            $table: $db.denverResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExaminationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExaminationsTable> {
  $$ExaminationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get examDate => $composableBuilder(
    column: $table.examDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get examinerNote => $composableBuilder(
    column: $table.examinerNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PatientsTableOrderingComposer get patientId {
    final $$PatientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableOrderingComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExaminationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExaminationsTable> {
  $$ExaminationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get examDate =>
      $composableBuilder(column: $table.examDate, builder: (column) => column);

  GeneratedColumn<String> get examinerNote => $composableBuilder(
    column: $table.examinerNote,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$PatientsTableAnnotationComposer get patientId {
    final $$PatientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.patientId,
      referencedTable: $db.patients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PatientsTableAnnotationComposer(
            $db: $db,
            $table: $db.patients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> growthMeasurementsRefs<T extends Object>(
    Expression<T> Function($$GrowthMeasurementsTableAnnotationComposer a) f,
  ) {
    final $$GrowthMeasurementsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.growthMeasurements,
          getReferencedColumn: (t) => t.examinationId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GrowthMeasurementsTableAnnotationComposer(
                $db: $db,
                $table: $db.growthMeasurements,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> kpspResultsRefs<T extends Object>(
    Expression<T> Function($$KpspResultsTableAnnotationComposer a) f,
  ) {
    final $$KpspResultsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.kpspResults,
      getReferencedColumn: (t) => t.examinationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KpspResultsTableAnnotationComposer(
            $db: $db,
            $table: $db.kpspResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> screeningResultsRefs<T extends Object>(
    Expression<T> Function($$ScreeningResultsTableAnnotationComposer a) f,
  ) {
    final $$ScreeningResultsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.screeningResults,
      getReferencedColumn: (t) => t.examinationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScreeningResultsTableAnnotationComposer(
            $db: $db,
            $table: $db.screeningResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> visionResultsRefs<T extends Object>(
    Expression<T> Function($$VisionResultsTableAnnotationComposer a) f,
  ) {
    final $$VisionResultsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.visionResults,
      getReferencedColumn: (t) => t.examinationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VisionResultsTableAnnotationComposer(
            $db: $db,
            $table: $db.visionResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> carsResultsRefs<T extends Object>(
    Expression<T> Function($$CarsResultsTableAnnotationComposer a) f,
  ) {
    final $$CarsResultsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.carsResults,
      getReferencedColumn: (t) => t.examinationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CarsResultsTableAnnotationComposer(
            $db: $db,
            $table: $db.carsResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> denverResultsRefs<T extends Object>(
    Expression<T> Function($$DenverResultsTableAnnotationComposer a) f,
  ) {
    final $$DenverResultsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.denverResults,
      getReferencedColumn: (t) => t.examinationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DenverResultsTableAnnotationComposer(
            $db: $db,
            $table: $db.denverResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExaminationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExaminationsTable,
          Examination,
          $$ExaminationsTableFilterComposer,
          $$ExaminationsTableOrderingComposer,
          $$ExaminationsTableAnnotationComposer,
          $$ExaminationsTableCreateCompanionBuilder,
          $$ExaminationsTableUpdateCompanionBuilder,
          (Examination, $$ExaminationsTableReferences),
          Examination,
          PrefetchHooks Function({
            bool patientId,
            bool growthMeasurementsRefs,
            bool kpspResultsRefs,
            bool screeningResultsRefs,
            bool visionResultsRefs,
            bool carsResultsRefs,
            bool denverResultsRefs,
          })
        > {
  $$ExaminationsTableTableManager(_$AppDatabase db, $ExaminationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExaminationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExaminationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExaminationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> patientId = const Value.absent(),
                Value<DateTime> examDate = const Value.absent(),
                Value<String?> examinerNote = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExaminationsCompanion(
                id: id,
                patientId: patientId,
                examDate: examDate,
                examinerNote: examinerNote,
                createdAt: createdAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String patientId,
                required DateTime examDate,
                Value<String?> examinerNote = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExaminationsCompanion.insert(
                id: id,
                patientId: patientId,
                examDate: examDate,
                examinerNote: examinerNote,
                createdAt: createdAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExaminationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                patientId = false,
                growthMeasurementsRefs = false,
                kpspResultsRefs = false,
                screeningResultsRefs = false,
                visionResultsRefs = false,
                carsResultsRefs = false,
                denverResultsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (growthMeasurementsRefs) db.growthMeasurements,
                    if (kpspResultsRefs) db.kpspResults,
                    if (screeningResultsRefs) db.screeningResults,
                    if (visionResultsRefs) db.visionResults,
                    if (carsResultsRefs) db.carsResults,
                    if (denverResultsRefs) db.denverResults,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (patientId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.patientId,
                                    referencedTable:
                                        $$ExaminationsTableReferences
                                            ._patientIdTable(db),
                                    referencedColumn:
                                        $$ExaminationsTableReferences
                                            ._patientIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (growthMeasurementsRefs)
                        await $_getPrefetchedData<
                          Examination,
                          $ExaminationsTable,
                          GrowthMeasurement
                        >(
                          currentTable: table,
                          referencedTable: $$ExaminationsTableReferences
                              ._growthMeasurementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExaminationsTableReferences(
                                db,
                                table,
                                p0,
                              ).growthMeasurementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.examinationId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (kpspResultsRefs)
                        await $_getPrefetchedData<
                          Examination,
                          $ExaminationsTable,
                          KpspResult
                        >(
                          currentTable: table,
                          referencedTable: $$ExaminationsTableReferences
                              ._kpspResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExaminationsTableReferences(
                                db,
                                table,
                                p0,
                              ).kpspResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.examinationId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (screeningResultsRefs)
                        await $_getPrefetchedData<
                          Examination,
                          $ExaminationsTable,
                          ScreeningResult
                        >(
                          currentTable: table,
                          referencedTable: $$ExaminationsTableReferences
                              ._screeningResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExaminationsTableReferences(
                                db,
                                table,
                                p0,
                              ).screeningResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.examinationId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (visionResultsRefs)
                        await $_getPrefetchedData<
                          Examination,
                          $ExaminationsTable,
                          VisionResult
                        >(
                          currentTable: table,
                          referencedTable: $$ExaminationsTableReferences
                              ._visionResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExaminationsTableReferences(
                                db,
                                table,
                                p0,
                              ).visionResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.examinationId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (carsResultsRefs)
                        await $_getPrefetchedData<
                          Examination,
                          $ExaminationsTable,
                          CarsResult
                        >(
                          currentTable: table,
                          referencedTable: $$ExaminationsTableReferences
                              ._carsResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExaminationsTableReferences(
                                db,
                                table,
                                p0,
                              ).carsResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.examinationId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (denverResultsRefs)
                        await $_getPrefetchedData<
                          Examination,
                          $ExaminationsTable,
                          DenverResult
                        >(
                          currentTable: table,
                          referencedTable: $$ExaminationsTableReferences
                              ._denverResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ExaminationsTableReferences(
                                db,
                                table,
                                p0,
                              ).denverResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.examinationId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ExaminationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExaminationsTable,
      Examination,
      $$ExaminationsTableFilterComposer,
      $$ExaminationsTableOrderingComposer,
      $$ExaminationsTableAnnotationComposer,
      $$ExaminationsTableCreateCompanionBuilder,
      $$ExaminationsTableUpdateCompanionBuilder,
      (Examination, $$ExaminationsTableReferences),
      Examination,
      PrefetchHooks Function({
        bool patientId,
        bool growthMeasurementsRefs,
        bool kpspResultsRefs,
        bool screeningResultsRefs,
        bool visionResultsRefs,
        bool carsResultsRefs,
        bool denverResultsRefs,
      })
    >;
typedef $$GrowthMeasurementsTableCreateCompanionBuilder =
    GrowthMeasurementsCompanion Function({
      Value<String> id,
      required String examinationId,
      Value<double?> weightKg,
      Value<double?> heightCm,
      Value<double?> headCircumferenceCm,
      Value<bool> measuredLying,
      Value<int> rowid,
    });
typedef $$GrowthMeasurementsTableUpdateCompanionBuilder =
    GrowthMeasurementsCompanion Function({
      Value<String> id,
      Value<String> examinationId,
      Value<double?> weightKg,
      Value<double?> heightCm,
      Value<double?> headCircumferenceCm,
      Value<bool> measuredLying,
      Value<int> rowid,
    });

final class $$GrowthMeasurementsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $GrowthMeasurementsTable,
          GrowthMeasurement
        > {
  $$GrowthMeasurementsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExaminationsTable _examinationIdTable(_$AppDatabase db) =>
      db.examinations.createAlias(
        $_aliasNameGenerator(
          db.growthMeasurements.examinationId,
          db.examinations.id,
        ),
      );

  $$ExaminationsTableProcessedTableManager get examinationId {
    final $_column = $_itemColumn<String>('examination_id')!;

    final manager = $$ExaminationsTableTableManager(
      $_db,
      $_db.examinations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_examinationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GrowthMeasurementsTableFilterComposer
    extends Composer<_$AppDatabase, $GrowthMeasurementsTable> {
  $$GrowthMeasurementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get headCircumferenceCm => $composableBuilder(
    column: $table.headCircumferenceCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get measuredLying => $composableBuilder(
    column: $table.measuredLying,
    builder: (column) => ColumnFilters(column),
  );

  $$ExaminationsTableFilterComposer get examinationId {
    final $$ExaminationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableFilterComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GrowthMeasurementsTableOrderingComposer
    extends Composer<_$AppDatabase, $GrowthMeasurementsTable> {
  $$GrowthMeasurementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get headCircumferenceCm => $composableBuilder(
    column: $table.headCircumferenceCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get measuredLying => $composableBuilder(
    column: $table.measuredLying,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExaminationsTableOrderingComposer get examinationId {
    final $$ExaminationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableOrderingComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GrowthMeasurementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GrowthMeasurementsTable> {
  $$GrowthMeasurementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get headCircumferenceCm => $composableBuilder(
    column: $table.headCircumferenceCm,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get measuredLying => $composableBuilder(
    column: $table.measuredLying,
    builder: (column) => column,
  );

  $$ExaminationsTableAnnotationComposer get examinationId {
    final $$ExaminationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableAnnotationComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GrowthMeasurementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GrowthMeasurementsTable,
          GrowthMeasurement,
          $$GrowthMeasurementsTableFilterComposer,
          $$GrowthMeasurementsTableOrderingComposer,
          $$GrowthMeasurementsTableAnnotationComposer,
          $$GrowthMeasurementsTableCreateCompanionBuilder,
          $$GrowthMeasurementsTableUpdateCompanionBuilder,
          (GrowthMeasurement, $$GrowthMeasurementsTableReferences),
          GrowthMeasurement,
          PrefetchHooks Function({bool examinationId})
        > {
  $$GrowthMeasurementsTableTableManager(
    _$AppDatabase db,
    $GrowthMeasurementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrowthMeasurementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrowthMeasurementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrowthMeasurementsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> examinationId = const Value.absent(),
                Value<double?> weightKg = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<double?> headCircumferenceCm = const Value.absent(),
                Value<bool> measuredLying = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GrowthMeasurementsCompanion(
                id: id,
                examinationId: examinationId,
                weightKg: weightKg,
                heightCm: heightCm,
                headCircumferenceCm: headCircumferenceCm,
                measuredLying: measuredLying,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String examinationId,
                Value<double?> weightKg = const Value.absent(),
                Value<double?> heightCm = const Value.absent(),
                Value<double?> headCircumferenceCm = const Value.absent(),
                Value<bool> measuredLying = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GrowthMeasurementsCompanion.insert(
                id: id,
                examinationId: examinationId,
                weightKg: weightKg,
                heightCm: heightCm,
                headCircumferenceCm: headCircumferenceCm,
                measuredLying: measuredLying,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GrowthMeasurementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({examinationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (examinationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.examinationId,
                                referencedTable:
                                    $$GrowthMeasurementsTableReferences
                                        ._examinationIdTable(db),
                                referencedColumn:
                                    $$GrowthMeasurementsTableReferences
                                        ._examinationIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GrowthMeasurementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GrowthMeasurementsTable,
      GrowthMeasurement,
      $$GrowthMeasurementsTableFilterComposer,
      $$GrowthMeasurementsTableOrderingComposer,
      $$GrowthMeasurementsTableAnnotationComposer,
      $$GrowthMeasurementsTableCreateCompanionBuilder,
      $$GrowthMeasurementsTableUpdateCompanionBuilder,
      (GrowthMeasurement, $$GrowthMeasurementsTableReferences),
      GrowthMeasurement,
      PrefetchHooks Function({bool examinationId})
    >;
typedef $$KpspResultsTableCreateCompanionBuilder =
    KpspResultsCompanion Function({
      Value<String> id,
      required String examinationId,
      required int formAgeMonths,
      required int yesCount,
      required int totalQuestions,
      required String result,
      required String answersJson,
      Value<int> rowid,
    });
typedef $$KpspResultsTableUpdateCompanionBuilder =
    KpspResultsCompanion Function({
      Value<String> id,
      Value<String> examinationId,
      Value<int> formAgeMonths,
      Value<int> yesCount,
      Value<int> totalQuestions,
      Value<String> result,
      Value<String> answersJson,
      Value<int> rowid,
    });

final class $$KpspResultsTableReferences
    extends BaseReferences<_$AppDatabase, $KpspResultsTable, KpspResult> {
  $$KpspResultsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExaminationsTable _examinationIdTable(_$AppDatabase db) =>
      db.examinations.createAlias(
        $_aliasNameGenerator(db.kpspResults.examinationId, db.examinations.id),
      );

  $$ExaminationsTableProcessedTableManager get examinationId {
    final $_column = $_itemColumn<String>('examination_id')!;

    final manager = $$ExaminationsTableTableManager(
      $_db,
      $_db.examinations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_examinationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$KpspResultsTableFilterComposer
    extends Composer<_$AppDatabase, $KpspResultsTable> {
  $$KpspResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get formAgeMonths => $composableBuilder(
    column: $table.formAgeMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get yesCount => $composableBuilder(
    column: $table.yesCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => ColumnFilters(column),
  );

  $$ExaminationsTableFilterComposer get examinationId {
    final $$ExaminationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableFilterComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KpspResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $KpspResultsTable> {
  $$KpspResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get formAgeMonths => $composableBuilder(
    column: $table.formAgeMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get yesCount => $composableBuilder(
    column: $table.yesCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get result => $composableBuilder(
    column: $table.result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExaminationsTableOrderingComposer get examinationId {
    final $$ExaminationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableOrderingComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KpspResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KpspResultsTable> {
  $$KpspResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get formAgeMonths => $composableBuilder(
    column: $table.formAgeMonths,
    builder: (column) => column,
  );

  GeneratedColumn<int> get yesCount =>
      $composableBuilder(column: $table.yesCount, builder: (column) => column);

  GeneratedColumn<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get result =>
      $composableBuilder(column: $table.result, builder: (column) => column);

  GeneratedColumn<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => column,
  );

  $$ExaminationsTableAnnotationComposer get examinationId {
    final $$ExaminationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableAnnotationComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KpspResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KpspResultsTable,
          KpspResult,
          $$KpspResultsTableFilterComposer,
          $$KpspResultsTableOrderingComposer,
          $$KpspResultsTableAnnotationComposer,
          $$KpspResultsTableCreateCompanionBuilder,
          $$KpspResultsTableUpdateCompanionBuilder,
          (KpspResult, $$KpspResultsTableReferences),
          KpspResult,
          PrefetchHooks Function({bool examinationId})
        > {
  $$KpspResultsTableTableManager(_$AppDatabase db, $KpspResultsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KpspResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KpspResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KpspResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> examinationId = const Value.absent(),
                Value<int> formAgeMonths = const Value.absent(),
                Value<int> yesCount = const Value.absent(),
                Value<int> totalQuestions = const Value.absent(),
                Value<String> result = const Value.absent(),
                Value<String> answersJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KpspResultsCompanion(
                id: id,
                examinationId: examinationId,
                formAgeMonths: formAgeMonths,
                yesCount: yesCount,
                totalQuestions: totalQuestions,
                result: result,
                answersJson: answersJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String examinationId,
                required int formAgeMonths,
                required int yesCount,
                required int totalQuestions,
                required String result,
                required String answersJson,
                Value<int> rowid = const Value.absent(),
              }) => KpspResultsCompanion.insert(
                id: id,
                examinationId: examinationId,
                formAgeMonths: formAgeMonths,
                yesCount: yesCount,
                totalQuestions: totalQuestions,
                result: result,
                answersJson: answersJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$KpspResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({examinationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (examinationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.examinationId,
                                referencedTable: $$KpspResultsTableReferences
                                    ._examinationIdTable(db),
                                referencedColumn: $$KpspResultsTableReferences
                                    ._examinationIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$KpspResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KpspResultsTable,
      KpspResult,
      $$KpspResultsTableFilterComposer,
      $$KpspResultsTableOrderingComposer,
      $$KpspResultsTableAnnotationComposer,
      $$KpspResultsTableCreateCompanionBuilder,
      $$KpspResultsTableUpdateCompanionBuilder,
      (KpspResult, $$KpspResultsTableReferences),
      KpspResult,
      PrefetchHooks Function({bool examinationId})
    >;
typedef $$ScreeningResultsTableCreateCompanionBuilder =
    ScreeningResultsCompanion Function({
      Value<String> id,
      required String examinationId,
      required String instrumentId,
      required int score,
      required int totalItems,
      required int riskLevel,
      required String answersJson,
      Value<String?> variantLabel,
      Value<int> rowid,
    });
typedef $$ScreeningResultsTableUpdateCompanionBuilder =
    ScreeningResultsCompanion Function({
      Value<String> id,
      Value<String> examinationId,
      Value<String> instrumentId,
      Value<int> score,
      Value<int> totalItems,
      Value<int> riskLevel,
      Value<String> answersJson,
      Value<String?> variantLabel,
      Value<int> rowid,
    });

final class $$ScreeningResultsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ScreeningResultsTable, ScreeningResult> {
  $$ScreeningResultsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExaminationsTable _examinationIdTable(_$AppDatabase db) =>
      db.examinations.createAlias(
        $_aliasNameGenerator(
          db.screeningResults.examinationId,
          db.examinations.id,
        ),
      );

  $$ExaminationsTableProcessedTableManager get examinationId {
    final $_column = $_itemColumn<String>('examination_id')!;

    final manager = $$ExaminationsTableTableManager(
      $_db,
      $_db.examinations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_examinationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ScreeningResultsTableFilterComposer
    extends Composer<_$AppDatabase, $ScreeningResultsTable> {
  $$ScreeningResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instrumentId => $composableBuilder(
    column: $table.instrumentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalItems => $composableBuilder(
    column: $table.totalItems,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get riskLevel => $composableBuilder(
    column: $table.riskLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variantLabel => $composableBuilder(
    column: $table.variantLabel,
    builder: (column) => ColumnFilters(column),
  );

  $$ExaminationsTableFilterComposer get examinationId {
    final $$ExaminationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableFilterComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScreeningResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScreeningResultsTable> {
  $$ScreeningResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instrumentId => $composableBuilder(
    column: $table.instrumentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalItems => $composableBuilder(
    column: $table.totalItems,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get riskLevel => $composableBuilder(
    column: $table.riskLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variantLabel => $composableBuilder(
    column: $table.variantLabel,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExaminationsTableOrderingComposer get examinationId {
    final $$ExaminationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableOrderingComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScreeningResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScreeningResultsTable> {
  $$ScreeningResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get instrumentId => $composableBuilder(
    column: $table.instrumentId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get totalItems => $composableBuilder(
    column: $table.totalItems,
    builder: (column) => column,
  );

  GeneratedColumn<int> get riskLevel =>
      $composableBuilder(column: $table.riskLevel, builder: (column) => column);

  GeneratedColumn<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get variantLabel => $composableBuilder(
    column: $table.variantLabel,
    builder: (column) => column,
  );

  $$ExaminationsTableAnnotationComposer get examinationId {
    final $$ExaminationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableAnnotationComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScreeningResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScreeningResultsTable,
          ScreeningResult,
          $$ScreeningResultsTableFilterComposer,
          $$ScreeningResultsTableOrderingComposer,
          $$ScreeningResultsTableAnnotationComposer,
          $$ScreeningResultsTableCreateCompanionBuilder,
          $$ScreeningResultsTableUpdateCompanionBuilder,
          (ScreeningResult, $$ScreeningResultsTableReferences),
          ScreeningResult,
          PrefetchHooks Function({bool examinationId})
        > {
  $$ScreeningResultsTableTableManager(
    _$AppDatabase db,
    $ScreeningResultsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScreeningResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScreeningResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScreeningResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> examinationId = const Value.absent(),
                Value<String> instrumentId = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<int> totalItems = const Value.absent(),
                Value<int> riskLevel = const Value.absent(),
                Value<String> answersJson = const Value.absent(),
                Value<String?> variantLabel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScreeningResultsCompanion(
                id: id,
                examinationId: examinationId,
                instrumentId: instrumentId,
                score: score,
                totalItems: totalItems,
                riskLevel: riskLevel,
                answersJson: answersJson,
                variantLabel: variantLabel,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String examinationId,
                required String instrumentId,
                required int score,
                required int totalItems,
                required int riskLevel,
                required String answersJson,
                Value<String?> variantLabel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScreeningResultsCompanion.insert(
                id: id,
                examinationId: examinationId,
                instrumentId: instrumentId,
                score: score,
                totalItems: totalItems,
                riskLevel: riskLevel,
                answersJson: answersJson,
                variantLabel: variantLabel,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ScreeningResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({examinationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (examinationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.examinationId,
                                referencedTable:
                                    $$ScreeningResultsTableReferences
                                        ._examinationIdTable(db),
                                referencedColumn:
                                    $$ScreeningResultsTableReferences
                                        ._examinationIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ScreeningResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScreeningResultsTable,
      ScreeningResult,
      $$ScreeningResultsTableFilterComposer,
      $$ScreeningResultsTableOrderingComposer,
      $$ScreeningResultsTableAnnotationComposer,
      $$ScreeningResultsTableCreateCompanionBuilder,
      $$ScreeningResultsTableUpdateCompanionBuilder,
      (ScreeningResult, $$ScreeningResultsTableReferences),
      ScreeningResult,
      PrefetchHooks Function({bool examinationId})
    >;
typedef $$VisionResultsTableCreateCompanionBuilder =
    VisionResultsCompanion Function({
      Value<String> id,
      required String examinationId,
      Value<int?> rightEyeLine,
      Value<int?> leftEyeLine,
      Value<int> rowid,
    });
typedef $$VisionResultsTableUpdateCompanionBuilder =
    VisionResultsCompanion Function({
      Value<String> id,
      Value<String> examinationId,
      Value<int?> rightEyeLine,
      Value<int?> leftEyeLine,
      Value<int> rowid,
    });

final class $$VisionResultsTableReferences
    extends BaseReferences<_$AppDatabase, $VisionResultsTable, VisionResult> {
  $$VisionResultsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExaminationsTable _examinationIdTable(_$AppDatabase db) =>
      db.examinations.createAlias(
        $_aliasNameGenerator(
          db.visionResults.examinationId,
          db.examinations.id,
        ),
      );

  $$ExaminationsTableProcessedTableManager get examinationId {
    final $_column = $_itemColumn<String>('examination_id')!;

    final manager = $$ExaminationsTableTableManager(
      $_db,
      $_db.examinations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_examinationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$VisionResultsTableFilterComposer
    extends Composer<_$AppDatabase, $VisionResultsTable> {
  $$VisionResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rightEyeLine => $composableBuilder(
    column: $table.rightEyeLine,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leftEyeLine => $composableBuilder(
    column: $table.leftEyeLine,
    builder: (column) => ColumnFilters(column),
  );

  $$ExaminationsTableFilterComposer get examinationId {
    final $$ExaminationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableFilterComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisionResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $VisionResultsTable> {
  $$VisionResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rightEyeLine => $composableBuilder(
    column: $table.rightEyeLine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leftEyeLine => $composableBuilder(
    column: $table.leftEyeLine,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExaminationsTableOrderingComposer get examinationId {
    final $$ExaminationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableOrderingComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisionResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VisionResultsTable> {
  $$VisionResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get rightEyeLine => $composableBuilder(
    column: $table.rightEyeLine,
    builder: (column) => column,
  );

  GeneratedColumn<int> get leftEyeLine => $composableBuilder(
    column: $table.leftEyeLine,
    builder: (column) => column,
  );

  $$ExaminationsTableAnnotationComposer get examinationId {
    final $$ExaminationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableAnnotationComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VisionResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VisionResultsTable,
          VisionResult,
          $$VisionResultsTableFilterComposer,
          $$VisionResultsTableOrderingComposer,
          $$VisionResultsTableAnnotationComposer,
          $$VisionResultsTableCreateCompanionBuilder,
          $$VisionResultsTableUpdateCompanionBuilder,
          (VisionResult, $$VisionResultsTableReferences),
          VisionResult,
          PrefetchHooks Function({bool examinationId})
        > {
  $$VisionResultsTableTableManager(_$AppDatabase db, $VisionResultsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VisionResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VisionResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VisionResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> examinationId = const Value.absent(),
                Value<int?> rightEyeLine = const Value.absent(),
                Value<int?> leftEyeLine = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VisionResultsCompanion(
                id: id,
                examinationId: examinationId,
                rightEyeLine: rightEyeLine,
                leftEyeLine: leftEyeLine,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String examinationId,
                Value<int?> rightEyeLine = const Value.absent(),
                Value<int?> leftEyeLine = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VisionResultsCompanion.insert(
                id: id,
                examinationId: examinationId,
                rightEyeLine: rightEyeLine,
                leftEyeLine: leftEyeLine,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$VisionResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({examinationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (examinationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.examinationId,
                                referencedTable: $$VisionResultsTableReferences
                                    ._examinationIdTable(db),
                                referencedColumn: $$VisionResultsTableReferences
                                    ._examinationIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$VisionResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VisionResultsTable,
      VisionResult,
      $$VisionResultsTableFilterComposer,
      $$VisionResultsTableOrderingComposer,
      $$VisionResultsTableAnnotationComposer,
      $$VisionResultsTableCreateCompanionBuilder,
      $$VisionResultsTableUpdateCompanionBuilder,
      (VisionResult, $$VisionResultsTableReferences),
      VisionResult,
      PrefetchHooks Function({bool examinationId})
    >;
typedef $$CarsResultsTableCreateCompanionBuilder =
    CarsResultsCompanion Function({
      Value<String> id,
      required String examinationId,
      required double totalScore,
      required int category,
      required String answersJson,
      Value<int> rowid,
    });
typedef $$CarsResultsTableUpdateCompanionBuilder =
    CarsResultsCompanion Function({
      Value<String> id,
      Value<String> examinationId,
      Value<double> totalScore,
      Value<int> category,
      Value<String> answersJson,
      Value<int> rowid,
    });

final class $$CarsResultsTableReferences
    extends BaseReferences<_$AppDatabase, $CarsResultsTable, CarsResult> {
  $$CarsResultsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExaminationsTable _examinationIdTable(_$AppDatabase db) =>
      db.examinations.createAlias(
        $_aliasNameGenerator(db.carsResults.examinationId, db.examinations.id),
      );

  $$ExaminationsTableProcessedTableManager get examinationId {
    final $_column = $_itemColumn<String>('examination_id')!;

    final manager = $$ExaminationsTableTableManager(
      $_db,
      $_db.examinations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_examinationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CarsResultsTableFilterComposer
    extends Composer<_$AppDatabase, $CarsResultsTable> {
  $$CarsResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => ColumnFilters(column),
  );

  $$ExaminationsTableFilterComposer get examinationId {
    final $$ExaminationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableFilterComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CarsResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $CarsResultsTable> {
  $$CarsResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExaminationsTableOrderingComposer get examinationId {
    final $$ExaminationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableOrderingComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CarsResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CarsResultsTable> {
  $$CarsResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => column,
  );

  $$ExaminationsTableAnnotationComposer get examinationId {
    final $$ExaminationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableAnnotationComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CarsResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CarsResultsTable,
          CarsResult,
          $$CarsResultsTableFilterComposer,
          $$CarsResultsTableOrderingComposer,
          $$CarsResultsTableAnnotationComposer,
          $$CarsResultsTableCreateCompanionBuilder,
          $$CarsResultsTableUpdateCompanionBuilder,
          (CarsResult, $$CarsResultsTableReferences),
          CarsResult,
          PrefetchHooks Function({bool examinationId})
        > {
  $$CarsResultsTableTableManager(_$AppDatabase db, $CarsResultsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CarsResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CarsResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CarsResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> examinationId = const Value.absent(),
                Value<double> totalScore = const Value.absent(),
                Value<int> category = const Value.absent(),
                Value<String> answersJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CarsResultsCompanion(
                id: id,
                examinationId: examinationId,
                totalScore: totalScore,
                category: category,
                answersJson: answersJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String examinationId,
                required double totalScore,
                required int category,
                required String answersJson,
                Value<int> rowid = const Value.absent(),
              }) => CarsResultsCompanion.insert(
                id: id,
                examinationId: examinationId,
                totalScore: totalScore,
                category: category,
                answersJson: answersJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CarsResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({examinationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (examinationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.examinationId,
                                referencedTable: $$CarsResultsTableReferences
                                    ._examinationIdTable(db),
                                referencedColumn: $$CarsResultsTableReferences
                                    ._examinationIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CarsResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CarsResultsTable,
      CarsResult,
      $$CarsResultsTableFilterComposer,
      $$CarsResultsTableOrderingComposer,
      $$CarsResultsTableAnnotationComposer,
      $$CarsResultsTableCreateCompanionBuilder,
      $$CarsResultsTableUpdateCompanionBuilder,
      (CarsResult, $$CarsResultsTableReferences),
      CarsResult,
      PrefetchHooks Function({bool examinationId})
    >;
typedef $$DenverResultsTableCreateCompanionBuilder =
    DenverResultsCompanion Function({
      Value<String> id,
      required String examinationId,
      required double ageInMonths,
      Value<bool> usedCorrectedAge,
      required int cautionsCount,
      required int delaysCount,
      required String globalResult,
      required String answersJson,
      Value<int> rowid,
    });
typedef $$DenverResultsTableUpdateCompanionBuilder =
    DenverResultsCompanion Function({
      Value<String> id,
      Value<String> examinationId,
      Value<double> ageInMonths,
      Value<bool> usedCorrectedAge,
      Value<int> cautionsCount,
      Value<int> delaysCount,
      Value<String> globalResult,
      Value<String> answersJson,
      Value<int> rowid,
    });

final class $$DenverResultsTableReferences
    extends BaseReferences<_$AppDatabase, $DenverResultsTable, DenverResult> {
  $$DenverResultsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ExaminationsTable _examinationIdTable(_$AppDatabase db) =>
      db.examinations.createAlias(
        $_aliasNameGenerator(
          db.denverResults.examinationId,
          db.examinations.id,
        ),
      );

  $$ExaminationsTableProcessedTableManager get examinationId {
    final $_column = $_itemColumn<String>('examination_id')!;

    final manager = $$ExaminationsTableTableManager(
      $_db,
      $_db.examinations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_examinationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DenverResultsTableFilterComposer
    extends Composer<_$AppDatabase, $DenverResultsTable> {
  $$DenverResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ageInMonths => $composableBuilder(
    column: $table.ageInMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get usedCorrectedAge => $composableBuilder(
    column: $table.usedCorrectedAge,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cautionsCount => $composableBuilder(
    column: $table.cautionsCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get delaysCount => $composableBuilder(
    column: $table.delaysCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get globalResult => $composableBuilder(
    column: $table.globalResult,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => ColumnFilters(column),
  );

  $$ExaminationsTableFilterComposer get examinationId {
    final $$ExaminationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableFilterComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DenverResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $DenverResultsTable> {
  $$DenverResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ageInMonths => $composableBuilder(
    column: $table.ageInMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get usedCorrectedAge => $composableBuilder(
    column: $table.usedCorrectedAge,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cautionsCount => $composableBuilder(
    column: $table.cautionsCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get delaysCount => $composableBuilder(
    column: $table.delaysCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get globalResult => $composableBuilder(
    column: $table.globalResult,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExaminationsTableOrderingComposer get examinationId {
    final $$ExaminationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableOrderingComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DenverResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DenverResultsTable> {
  $$DenverResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get ageInMonths => $composableBuilder(
    column: $table.ageInMonths,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get usedCorrectedAge => $composableBuilder(
    column: $table.usedCorrectedAge,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cautionsCount => $composableBuilder(
    column: $table.cautionsCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get delaysCount => $composableBuilder(
    column: $table.delaysCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get globalResult => $composableBuilder(
    column: $table.globalResult,
    builder: (column) => column,
  );

  GeneratedColumn<String> get answersJson => $composableBuilder(
    column: $table.answersJson,
    builder: (column) => column,
  );

  $$ExaminationsTableAnnotationComposer get examinationId {
    final $$ExaminationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.examinationId,
      referencedTable: $db.examinations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExaminationsTableAnnotationComposer(
            $db: $db,
            $table: $db.examinations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DenverResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DenverResultsTable,
          DenverResult,
          $$DenverResultsTableFilterComposer,
          $$DenverResultsTableOrderingComposer,
          $$DenverResultsTableAnnotationComposer,
          $$DenverResultsTableCreateCompanionBuilder,
          $$DenverResultsTableUpdateCompanionBuilder,
          (DenverResult, $$DenverResultsTableReferences),
          DenverResult,
          PrefetchHooks Function({bool examinationId})
        > {
  $$DenverResultsTableTableManager(_$AppDatabase db, $DenverResultsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DenverResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DenverResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DenverResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> examinationId = const Value.absent(),
                Value<double> ageInMonths = const Value.absent(),
                Value<bool> usedCorrectedAge = const Value.absent(),
                Value<int> cautionsCount = const Value.absent(),
                Value<int> delaysCount = const Value.absent(),
                Value<String> globalResult = const Value.absent(),
                Value<String> answersJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DenverResultsCompanion(
                id: id,
                examinationId: examinationId,
                ageInMonths: ageInMonths,
                usedCorrectedAge: usedCorrectedAge,
                cautionsCount: cautionsCount,
                delaysCount: delaysCount,
                globalResult: globalResult,
                answersJson: answersJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String examinationId,
                required double ageInMonths,
                Value<bool> usedCorrectedAge = const Value.absent(),
                required int cautionsCount,
                required int delaysCount,
                required String globalResult,
                required String answersJson,
                Value<int> rowid = const Value.absent(),
              }) => DenverResultsCompanion.insert(
                id: id,
                examinationId: examinationId,
                ageInMonths: ageInMonths,
                usedCorrectedAge: usedCorrectedAge,
                cautionsCount: cautionsCount,
                delaysCount: delaysCount,
                globalResult: globalResult,
                answersJson: answersJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DenverResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({examinationId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (examinationId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.examinationId,
                                referencedTable: $$DenverResultsTableReferences
                                    ._examinationIdTable(db),
                                referencedColumn: $$DenverResultsTableReferences
                                    ._examinationIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DenverResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DenverResultsTable,
      DenverResult,
      $$DenverResultsTableFilterComposer,
      $$DenverResultsTableOrderingComposer,
      $$DenverResultsTableAnnotationComposer,
      $$DenverResultsTableCreateCompanionBuilder,
      $$DenverResultsTableUpdateCompanionBuilder,
      (DenverResult, $$DenverResultsTableReferences),
      DenverResult,
      PrefetchHooks Function({bool examinationId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PatientsTableTableManager get patients =>
      $$PatientsTableTableManager(_db, _db.patients);
  $$ExaminationsTableTableManager get examinations =>
      $$ExaminationsTableTableManager(_db, _db.examinations);
  $$GrowthMeasurementsTableTableManager get growthMeasurements =>
      $$GrowthMeasurementsTableTableManager(_db, _db.growthMeasurements);
  $$KpspResultsTableTableManager get kpspResults =>
      $$KpspResultsTableTableManager(_db, _db.kpspResults);
  $$ScreeningResultsTableTableManager get screeningResults =>
      $$ScreeningResultsTableTableManager(_db, _db.screeningResults);
  $$VisionResultsTableTableManager get visionResults =>
      $$VisionResultsTableTableManager(_db, _db.visionResults);
  $$CarsResultsTableTableManager get carsResults =>
      $$CarsResultsTableTableManager(_db, _db.carsResults);
  $$DenverResultsTableTableManager get denverResults =>
      $$DenverResultsTableTableManager(_db, _db.denverResults);
}
