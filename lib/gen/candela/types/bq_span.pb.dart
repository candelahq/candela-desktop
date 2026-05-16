//
//  Generated code. Do not modify.
//  source: candela/types/bq_span.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/timestamp.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// BqSpanRow is the flattened BigQuery projection of a Span.
/// This message is the SINGLE SOURCE OF TRUTH for the `spans` table schema.
/// Generated schema: gen/bq/spans.schema
///
/// Proto → `buf generate` → gen/bq/spans.schema → Terraform file() reference
class BqSpanRow extends $pb.GeneratedMessage {
  factory BqSpanRow({
    $core.String? spanId,
    $core.String? traceId,
    $core.String? parentSpanId,
    $core.String? name,
    $core.int? kind,
    $core.int? status,
    $core.String? statusMessage,
    $2.Timestamp? startTime,
    $2.Timestamp? endTime,
    $fixnum.Int64? durationNs,
    $core.String? projectId,
    $core.String? environment,
    $core.String? serviceName,
    $core.String? userId,
    $core.String? sessionId,
    $core.String? tenantId,
    $core.String? jobId,
    $core.String? traceGroup,
    $core.String? genAiModel,
    $core.String? genAiProvider,
    $fixnum.Int64? genAiInputTokens,
    $fixnum.Int64? genAiOutputTokens,
    $fixnum.Int64? genAiTotalTokens,
    $core.double? genAiCostUsd,
    $core.double? genAiTemperature,
    $fixnum.Int64? genAiMaxTokens,
    $core.String? genAiInputContent,
    $core.String? genAiOutputContent,
    $core.Iterable<BqAttribute>? attributes,
    $core.Iterable<BqAttribute>? labels,
  }) {
    final $result = create();
    if (spanId != null) {
      $result.spanId = spanId;
    }
    if (traceId != null) {
      $result.traceId = traceId;
    }
    if (parentSpanId != null) {
      $result.parentSpanId = parentSpanId;
    }
    if (name != null) {
      $result.name = name;
    }
    if (kind != null) {
      $result.kind = kind;
    }
    if (status != null) {
      $result.status = status;
    }
    if (statusMessage != null) {
      $result.statusMessage = statusMessage;
    }
    if (startTime != null) {
      $result.startTime = startTime;
    }
    if (endTime != null) {
      $result.endTime = endTime;
    }
    if (durationNs != null) {
      $result.durationNs = durationNs;
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (environment != null) {
      $result.environment = environment;
    }
    if (serviceName != null) {
      $result.serviceName = serviceName;
    }
    if (userId != null) {
      $result.userId = userId;
    }
    if (sessionId != null) {
      $result.sessionId = sessionId;
    }
    if (tenantId != null) {
      $result.tenantId = tenantId;
    }
    if (jobId != null) {
      $result.jobId = jobId;
    }
    if (traceGroup != null) {
      $result.traceGroup = traceGroup;
    }
    if (genAiModel != null) {
      $result.genAiModel = genAiModel;
    }
    if (genAiProvider != null) {
      $result.genAiProvider = genAiProvider;
    }
    if (genAiInputTokens != null) {
      $result.genAiInputTokens = genAiInputTokens;
    }
    if (genAiOutputTokens != null) {
      $result.genAiOutputTokens = genAiOutputTokens;
    }
    if (genAiTotalTokens != null) {
      $result.genAiTotalTokens = genAiTotalTokens;
    }
    if (genAiCostUsd != null) {
      $result.genAiCostUsd = genAiCostUsd;
    }
    if (genAiTemperature != null) {
      $result.genAiTemperature = genAiTemperature;
    }
    if (genAiMaxTokens != null) {
      $result.genAiMaxTokens = genAiMaxTokens;
    }
    if (genAiInputContent != null) {
      $result.genAiInputContent = genAiInputContent;
    }
    if (genAiOutputContent != null) {
      $result.genAiOutputContent = genAiOutputContent;
    }
    if (attributes != null) {
      $result.attributes.addAll(attributes);
    }
    if (labels != null) {
      $result.labels.addAll(labels);
    }
    return $result;
  }
  BqSpanRow._() : super();
  factory BqSpanRow.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BqSpanRow.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BqSpanRow',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.types'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'spanId')
    ..aOS(2, _omitFieldNames ? '' : 'traceId')
    ..aOS(3, _omitFieldNames ? '' : 'parentSpanId')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..a<$core.int>(5, _omitFieldNames ? '' : 'kind', $pb.PbFieldType.O3)
    ..a<$core.int>(6, _omitFieldNames ? '' : 'status', $pb.PbFieldType.O3)
    ..aOS(7, _omitFieldNames ? '' : 'statusMessage')
    ..aOM<$2.Timestamp>(10, _omitFieldNames ? '' : 'startTime',
        subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(11, _omitFieldNames ? '' : 'endTime',
        subBuilder: $2.Timestamp.create)
    ..aInt64(12, _omitFieldNames ? '' : 'durationNs')
    ..aOS(20, _omitFieldNames ? '' : 'projectId')
    ..aOS(21, _omitFieldNames ? '' : 'environment')
    ..aOS(22, _omitFieldNames ? '' : 'serviceName')
    ..aOS(23, _omitFieldNames ? '' : 'userId')
    ..aOS(24, _omitFieldNames ? '' : 'sessionId')
    ..aOS(25, _omitFieldNames ? '' : 'tenantId')
    ..aOS(26, _omitFieldNames ? '' : 'jobId')
    ..aOS(27, _omitFieldNames ? '' : 'traceGroup')
    ..aOS(30, _omitFieldNames ? '' : 'genAiModel')
    ..aOS(31, _omitFieldNames ? '' : 'genAiProvider')
    ..aInt64(32, _omitFieldNames ? '' : 'genAiInputTokens')
    ..aInt64(33, _omitFieldNames ? '' : 'genAiOutputTokens')
    ..aInt64(34, _omitFieldNames ? '' : 'genAiTotalTokens')
    ..a<$core.double>(
        35, _omitFieldNames ? '' : 'genAiCostUsd', $pb.PbFieldType.OD)
    ..a<$core.double>(
        36, _omitFieldNames ? '' : 'genAiTemperature', $pb.PbFieldType.OD)
    ..aInt64(37, _omitFieldNames ? '' : 'genAiMaxTokens')
    ..aOS(38, _omitFieldNames ? '' : 'genAiInputContent')
    ..aOS(39, _omitFieldNames ? '' : 'genAiOutputContent')
    ..pc<BqAttribute>(
        40, _omitFieldNames ? '' : 'attributes', $pb.PbFieldType.PM,
        subBuilder: BqAttribute.create)
    ..pc<BqAttribute>(41, _omitFieldNames ? '' : 'labels', $pb.PbFieldType.PM,
        subBuilder: BqAttribute.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BqSpanRow clone() => BqSpanRow()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BqSpanRow copyWith(void Function(BqSpanRow) updates) =>
      super.copyWith((message) => updates(message as BqSpanRow)) as BqSpanRow;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BqSpanRow create() => BqSpanRow._();
  BqSpanRow createEmptyInstance() => create();
  static $pb.PbList<BqSpanRow> createRepeated() => $pb.PbList<BqSpanRow>();
  @$core.pragma('dart2js:noInline')
  static BqSpanRow getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BqSpanRow>(create);
  static BqSpanRow? _defaultInstance;

  /// Unique identifier for the span.
  @$pb.TagNumber(1)
  $core.String get spanId => $_getSZ(0);
  @$pb.TagNumber(1)
  set spanId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasSpanId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSpanId() => $_clearField(1);

  /// Unique identifier for the trace this span belongs to.
  @$pb.TagNumber(2)
  $core.String get traceId => $_getSZ(1);
  @$pb.TagNumber(2)
  set traceId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTraceId() => $_has(1);
  @$pb.TagNumber(2)
  void clearTraceId() => $_clearField(2);

  /// Identifier of the parent span, if this is a child span.
  @$pb.TagNumber(3)
  $core.String get parentSpanId => $_getSZ(2);
  @$pb.TagNumber(3)
  set parentSpanId($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasParentSpanId() => $_has(2);
  @$pb.TagNumber(3)
  void clearParentSpanId() => $_clearField(3);

  /// A human-readable name for the span.
  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  /// The kind of span (LLM, agent, tool, etc.), as a SpanKind enum int.
  @$pb.TagNumber(5)
  $core.int get kind => $_getIZ(4);
  @$pb.TagNumber(5)
  set kind($core.int v) {
    $_setSignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasKind() => $_has(4);
  @$pb.TagNumber(5)
  void clearKind() => $_clearField(5);

  /// The status of the span (ok, error), as a SpanStatus enum int.
  @$pb.TagNumber(6)
  $core.int get status => $_getIZ(5);
  @$pb.TagNumber(6)
  set status($core.int v) {
    $_setSignedInt32(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  /// A description of the status, present if status is error.
  @$pb.TagNumber(7)
  $core.String get statusMessage => $_getSZ(6);
  @$pb.TagNumber(7)
  set statusMessage($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasStatusMessage() => $_has(6);
  @$pb.TagNumber(7)
  void clearStatusMessage() => $_clearField(7);

  /// The time the span started, in UTC.
  @$pb.TagNumber(10)
  $2.Timestamp get startTime => $_getN(7);
  @$pb.TagNumber(10)
  set startTime($2.Timestamp v) {
    $_setField(10, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasStartTime() => $_has(7);
  @$pb.TagNumber(10)
  void clearStartTime() => $_clearField(10);
  @$pb.TagNumber(10)
  $2.Timestamp ensureStartTime() => $_ensure(7);

  /// The time the span ended, in UTC.
  @$pb.TagNumber(11)
  $2.Timestamp get endTime => $_getN(8);
  @$pb.TagNumber(11)
  set endTime($2.Timestamp v) {
    $_setField(11, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasEndTime() => $_has(8);
  @$pb.TagNumber(11)
  void clearEndTime() => $_clearField(11);
  @$pb.TagNumber(11)
  $2.Timestamp ensureEndTime() => $_ensure(8);

  /// The duration of the span in nanoseconds.
  @$pb.TagNumber(12)
  $fixnum.Int64 get durationNs => $_getI64(9);
  @$pb.TagNumber(12)
  set durationNs($fixnum.Int64 v) {
    $_setInt64(9, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasDurationNs() => $_has(9);
  @$pb.TagNumber(12)
  void clearDurationNs() => $_clearField(12);

  /// The ID of the project this span belongs to.
  @$pb.TagNumber(20)
  $core.String get projectId => $_getSZ(10);
  @$pb.TagNumber(20)
  set projectId($core.String v) {
    $_setString(10, v);
  }

  @$pb.TagNumber(20)
  $core.bool hasProjectId() => $_has(10);
  @$pb.TagNumber(20)
  void clearProjectId() => $_clearField(20);

  /// The deployment environment (e.g., production, staging).
  @$pb.TagNumber(21)
  $core.String get environment => $_getSZ(11);
  @$pb.TagNumber(21)
  set environment($core.String v) {
    $_setString(11, v);
  }

  @$pb.TagNumber(21)
  $core.bool hasEnvironment() => $_has(11);
  @$pb.TagNumber(21)
  void clearEnvironment() => $_clearField(21);

  /// The name of the service that generated this span.
  @$pb.TagNumber(22)
  $core.String get serviceName => $_getSZ(12);
  @$pb.TagNumber(22)
  set serviceName($core.String v) {
    $_setString(12, v);
  }

  @$pb.TagNumber(22)
  $core.bool hasServiceName() => $_has(12);
  @$pb.TagNumber(22)
  void clearServiceName() => $_clearField(22);

  /// The developer who triggered this span.
  @$pb.TagNumber(23)
  $core.String get userId => $_getSZ(13);
  @$pb.TagNumber(23)
  set userId($core.String v) {
    $_setString(13, v);
  }

  @$pb.TagNumber(23)
  $core.bool hasUserId() => $_has(13);
  @$pb.TagNumber(23)
  void clearUserId() => $_clearField(23);

  /// Conversation/session identifier for grouping related spans.
  @$pb.TagNumber(24)
  $core.String get sessionId => $_getSZ(14);
  @$pb.TagNumber(24)
  set sessionId($core.String v) {
    $_setString(14, v);
  }

  @$pb.TagNumber(24)
  $core.bool hasSessionId() => $_has(14);
  @$pb.TagNumber(24)
  void clearSessionId() => $_clearField(24);

  /// Downstream tenant for multitenant cost attribution.
  @$pb.TagNumber(25)
  $core.String get tenantId => $_getSZ(15);
  @$pb.TagNumber(25)
  set tenantId($core.String v) {
    $_setString(15, v);
  }

  @$pb.TagNumber(25)
  $core.bool hasTenantId() => $_has(15);
  @$pb.TagNumber(25)
  void clearTenantId() => $_clearField(25);

  /// Job/experiment identifier.
  @$pb.TagNumber(26)
  $core.String get jobId => $_getSZ(16);
  @$pb.TagNumber(26)
  set jobId($core.String v) {
    $_setString(16, v);
  }

  @$pb.TagNumber(26)
  $core.bool hasJobId() => $_has(16);
  @$pb.TagNumber(26)
  void clearJobId() => $_clearField(26);

  /// Logical trace group for multi-step agent correlation.
  @$pb.TagNumber(27)
  $core.String get traceGroup => $_getSZ(17);
  @$pb.TagNumber(27)
  set traceGroup($core.String v) {
    $_setString(17, v);
  }

  @$pb.TagNumber(27)
  $core.bool hasTraceGroup() => $_has(17);
  @$pb.TagNumber(27)
  void clearTraceGroup() => $_clearField(27);

  /// GenAI model identifier (e.g., gpt-4o, gemini-2.5-pro).
  @$pb.TagNumber(30)
  $core.String get genAiModel => $_getSZ(18);
  @$pb.TagNumber(30)
  set genAiModel($core.String v) {
    $_setString(18, v);
  }

  @$pb.TagNumber(30)
  $core.bool hasGenAiModel() => $_has(18);
  @$pb.TagNumber(30)
  void clearGenAiModel() => $_clearField(30);

  /// GenAI provider (e.g., openai, google_ai, anthropic).
  @$pb.TagNumber(31)
  $core.String get genAiProvider => $_getSZ(19);
  @$pb.TagNumber(31)
  set genAiProvider($core.String v) {
    $_setString(19, v);
  }

  @$pb.TagNumber(31)
  $core.bool hasGenAiProvider() => $_has(19);
  @$pb.TagNumber(31)
  void clearGenAiProvider() => $_clearField(31);

  /// Number of input/prompt tokens.
  @$pb.TagNumber(32)
  $fixnum.Int64 get genAiInputTokens => $_getI64(20);
  @$pb.TagNumber(32)
  set genAiInputTokens($fixnum.Int64 v) {
    $_setInt64(20, v);
  }

  @$pb.TagNumber(32)
  $core.bool hasGenAiInputTokens() => $_has(20);
  @$pb.TagNumber(32)
  void clearGenAiInputTokens() => $_clearField(32);

  /// Number of output/completion tokens.
  @$pb.TagNumber(33)
  $fixnum.Int64 get genAiOutputTokens => $_getI64(21);
  @$pb.TagNumber(33)
  set genAiOutputTokens($fixnum.Int64 v) {
    $_setInt64(21, v);
  }

  @$pb.TagNumber(33)
  $core.bool hasGenAiOutputTokens() => $_has(21);
  @$pb.TagNumber(33)
  void clearGenAiOutputTokens() => $_clearField(33);

  /// Total tokens (input + output).
  @$pb.TagNumber(34)
  $fixnum.Int64 get genAiTotalTokens => $_getI64(22);
  @$pb.TagNumber(34)
  set genAiTotalTokens($fixnum.Int64 v) {
    $_setInt64(22, v);
  }

  @$pb.TagNumber(34)
  $core.bool hasGenAiTotalTokens() => $_has(22);
  @$pb.TagNumber(34)
  void clearGenAiTotalTokens() => $_clearField(34);

  /// Estimated cost in USD, calculated by Candela.
  @$pb.TagNumber(35)
  $core.double get genAiCostUsd => $_getN(23);
  @$pb.TagNumber(35)
  set genAiCostUsd($core.double v) {
    $_setDouble(23, v);
  }

  @$pb.TagNumber(35)
  $core.bool hasGenAiCostUsd() => $_has(23);
  @$pb.TagNumber(35)
  void clearGenAiCostUsd() => $_clearField(35);

  /// Sampling temperature used for the request.
  @$pb.TagNumber(36)
  $core.double get genAiTemperature => $_getN(24);
  @$pb.TagNumber(36)
  set genAiTemperature($core.double v) {
    $_setDouble(24, v);
  }

  @$pb.TagNumber(36)
  $core.bool hasGenAiTemperature() => $_has(24);
  @$pb.TagNumber(36)
  void clearGenAiTemperature() => $_clearField(36);

  /// Max tokens requested for the completion.
  @$pb.TagNumber(37)
  $fixnum.Int64 get genAiMaxTokens => $_getI64(25);
  @$pb.TagNumber(37)
  set genAiMaxTokens($fixnum.Int64 v) {
    $_setInt64(25, v);
  }

  @$pb.TagNumber(37)
  $core.bool hasGenAiMaxTokens() => $_has(25);
  @$pb.TagNumber(37)
  void clearGenAiMaxTokens() => $_clearField(37);

  /// Input prompt content.
  @$pb.TagNumber(38)
  $core.String get genAiInputContent => $_getSZ(26);
  @$pb.TagNumber(38)
  set genAiInputContent($core.String v) {
    $_setString(26, v);
  }

  @$pb.TagNumber(38)
  $core.bool hasGenAiInputContent() => $_has(26);
  @$pb.TagNumber(38)
  void clearGenAiInputContent() => $_clearField(38);

  /// Output completion content.
  @$pb.TagNumber(39)
  $core.String get genAiOutputContent => $_getSZ(27);
  @$pb.TagNumber(39)
  set genAiOutputContent($core.String v) {
    $_setString(27, v);
  }

  @$pb.TagNumber(39)
  $core.bool hasGenAiOutputContent() => $_has(27);
  @$pb.TagNumber(39)
  void clearGenAiOutputContent() => $_clearField(39);

  /// Structured attributes from OpenTelemetry key-value pairs.
  @$pb.TagNumber(40)
  $pb.PbList<BqAttribute> get attributes => $_getList(28);

  /// User-defined labels for custom filtering and cost attribution.
  /// Set via X-Candela-Labels header (comma-separated k=v pairs).
  @$pb.TagNumber(41)
  $pb.PbList<BqAttribute> get labels => $_getList(29);
}

/// BqAttribute is a key-value pair stored as a RECORD in BigQuery.
class BqAttribute extends $pb.GeneratedMessage {
  factory BqAttribute({
    $core.String? key,
    $core.String? value,
  }) {
    final $result = create();
    if (key != null) {
      $result.key = key;
    }
    if (value != null) {
      $result.value = value;
    }
    return $result;
  }
  BqAttribute._() : super();
  factory BqAttribute.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BqAttribute.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'BqAttribute',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.types'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'key')
    ..aOS(2, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BqAttribute clone() => BqAttribute()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BqAttribute copyWith(void Function(BqAttribute) updates) =>
      super.copyWith((message) => updates(message as BqAttribute))
          as BqAttribute;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BqAttribute create() => BqAttribute._();
  BqAttribute createEmptyInstance() => create();
  static $pb.PbList<BqAttribute> createRepeated() => $pb.PbList<BqAttribute>();
  @$core.pragma('dart2js:noInline')
  static BqAttribute getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<BqAttribute>(create);
  static BqAttribute? _defaultInstance;

  /// The attribute key.
  @$pb.TagNumber(1)
  $core.String get key => $_getSZ(0);
  @$pb.TagNumber(1)
  set key($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => $_clearField(1);

  /// The attribute value (stringified).
  @$pb.TagNumber(2)
  $core.String get value => $_getSZ(1);
  @$pb.TagNumber(2)
  set value($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
