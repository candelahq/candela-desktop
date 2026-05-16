//
//  Generated code. Do not modify.
//  source: candela/types/trace.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../google/protobuf/duration.pb.dart' as $0;
import '../../google/protobuf/timestamp.pb.dart' as $2;
import 'common.pb.dart' as $4;
import 'trace.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'trace.pbenum.dart';

/// GenAI-specific attributes extracted from OTel semantic conventions.
class GenAIAttributes extends $pb.GeneratedMessage {
  factory GenAIAttributes({
    $core.String? model,
    $core.String? provider,
    $fixnum.Int64? inputTokens,
    $fixnum.Int64? outputTokens,
    $fixnum.Int64? totalTokens,
    $core.double? costUsd,
    $core.double? temperature,
    $fixnum.Int64? maxTokens,
    $core.double? topP,
    $core.String? inputContent,
    $core.String? outputContent,
    $core.String? inputContentRef,
    $core.String? outputContentRef,
  }) {
    final $result = create();
    if (model != null) {
      $result.model = model;
    }
    if (provider != null) {
      $result.provider = provider;
    }
    if (inputTokens != null) {
      $result.inputTokens = inputTokens;
    }
    if (outputTokens != null) {
      $result.outputTokens = outputTokens;
    }
    if (totalTokens != null) {
      $result.totalTokens = totalTokens;
    }
    if (costUsd != null) {
      $result.costUsd = costUsd;
    }
    if (temperature != null) {
      $result.temperature = temperature;
    }
    if (maxTokens != null) {
      $result.maxTokens = maxTokens;
    }
    if (topP != null) {
      $result.topP = topP;
    }
    if (inputContent != null) {
      $result.inputContent = inputContent;
    }
    if (outputContent != null) {
      $result.outputContent = outputContent;
    }
    if (inputContentRef != null) {
      $result.inputContentRef = inputContentRef;
    }
    if (outputContentRef != null) {
      $result.outputContentRef = outputContentRef;
    }
    return $result;
  }
  GenAIAttributes._() : super();
  factory GenAIAttributes.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GenAIAttributes.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GenAIAttributes',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.types'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'model')
    ..aOS(2, _omitFieldNames ? '' : 'provider')
    ..aInt64(10, _omitFieldNames ? '' : 'inputTokens')
    ..aInt64(11, _omitFieldNames ? '' : 'outputTokens')
    ..aInt64(12, _omitFieldNames ? '' : 'totalTokens')
    ..a<$core.double>(20, _omitFieldNames ? '' : 'costUsd', $pb.PbFieldType.OD)
    ..a<$core.double>(
        30, _omitFieldNames ? '' : 'temperature', $pb.PbFieldType.OD)
    ..aInt64(31, _omitFieldNames ? '' : 'maxTokens')
    ..a<$core.double>(32, _omitFieldNames ? '' : 'topP', $pb.PbFieldType.OD)
    ..aOS(40, _omitFieldNames ? '' : 'inputContent')
    ..aOS(41, _omitFieldNames ? '' : 'outputContent')
    ..aOS(42, _omitFieldNames ? '' : 'inputContentRef')
    ..aOS(43, _omitFieldNames ? '' : 'outputContentRef')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenAIAttributes clone() => GenAIAttributes()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GenAIAttributes copyWith(void Function(GenAIAttributes) updates) =>
      super.copyWith((message) => updates(message as GenAIAttributes))
          as GenAIAttributes;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GenAIAttributes create() => GenAIAttributes._();
  GenAIAttributes createEmptyInstance() => create();
  static $pb.PbList<GenAIAttributes> createRepeated() =>
      $pb.PbList<GenAIAttributes>();
  @$core.pragma('dart2js:noInline')
  static GenAIAttributes getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GenAIAttributes>(create);
  static GenAIAttributes? _defaultInstance;

  /// Model information
  @$pb.TagNumber(1)
  $core.String get model => $_getSZ(0);
  @$pb.TagNumber(1)
  set model($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasModel() => $_has(0);
  @$pb.TagNumber(1)
  void clearModel() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get provider => $_getSZ(1);
  @$pb.TagNumber(2)
  set provider($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasProvider() => $_has(1);
  @$pb.TagNumber(2)
  void clearProvider() => $_clearField(2);

  /// Token usage
  @$pb.TagNumber(10)
  $fixnum.Int64 get inputTokens => $_getI64(2);
  @$pb.TagNumber(10)
  set inputTokens($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasInputTokens() => $_has(2);
  @$pb.TagNumber(10)
  void clearInputTokens() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get outputTokens => $_getI64(3);
  @$pb.TagNumber(11)
  set outputTokens($fixnum.Int64 v) {
    $_setInt64(3, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasOutputTokens() => $_has(3);
  @$pb.TagNumber(11)
  void clearOutputTokens() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get totalTokens => $_getI64(4);
  @$pb.TagNumber(12)
  set totalTokens($fixnum.Int64 v) {
    $_setInt64(4, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasTotalTokens() => $_has(4);
  @$pb.TagNumber(12)
  void clearTotalTokens() => $_clearField(12);

  /// Cost (calculated by Candela)
  @$pb.TagNumber(20)
  $core.double get costUsd => $_getN(5);
  @$pb.TagNumber(20)
  set costUsd($core.double v) {
    $_setDouble(5, v);
  }

  @$pb.TagNumber(20)
  $core.bool hasCostUsd() => $_has(5);
  @$pb.TagNumber(20)
  void clearCostUsd() => $_clearField(20);

  /// Request parameters
  @$pb.TagNumber(30)
  $core.double get temperature => $_getN(6);
  @$pb.TagNumber(30)
  set temperature($core.double v) {
    $_setDouble(6, v);
  }

  @$pb.TagNumber(30)
  $core.bool hasTemperature() => $_has(6);
  @$pb.TagNumber(30)
  void clearTemperature() => $_clearField(30);

  @$pb.TagNumber(31)
  $fixnum.Int64 get maxTokens => $_getI64(7);
  @$pb.TagNumber(31)
  set maxTokens($fixnum.Int64 v) {
    $_setInt64(7, v);
  }

  @$pb.TagNumber(31)
  $core.bool hasMaxTokens() => $_has(7);
  @$pb.TagNumber(31)
  void clearMaxTokens() => $_clearField(31);

  @$pb.TagNumber(32)
  $core.double get topP => $_getN(8);
  @$pb.TagNumber(32)
  set topP($core.double v) {
    $_setDouble(8, v);
  }

  @$pb.TagNumber(32)
  $core.bool hasTopP() => $_has(8);
  @$pb.TagNumber(32)
  void clearTopP() => $_clearField(32);

  /// Content (optional, can be large — use ref fields for content exceeding 1MB)
  @$pb.TagNumber(40)
  $core.String get inputContent => $_getSZ(9);
  @$pb.TagNumber(40)
  set inputContent($core.String v) {
    $_setString(9, v);
  }

  @$pb.TagNumber(40)
  $core.bool hasInputContent() => $_has(9);
  @$pb.TagNumber(40)
  void clearInputContent() => $_clearField(40);

  @$pb.TagNumber(41)
  $core.String get outputContent => $_getSZ(10);
  @$pb.TagNumber(41)
  set outputContent($core.String v) {
    $_setString(10, v);
  }

  @$pb.TagNumber(41)
  $core.bool hasOutputContent() => $_has(10);
  @$pb.TagNumber(41)
  void clearOutputContent() => $_clearField(41);

  @$pb.TagNumber(42)
  $core.String get inputContentRef => $_getSZ(11);
  @$pb.TagNumber(42)
  set inputContentRef($core.String v) {
    $_setString(11, v);
  }

  @$pb.TagNumber(42)
  $core.bool hasInputContentRef() => $_has(11);
  @$pb.TagNumber(42)
  void clearInputContentRef() => $_clearField(42);

  @$pb.TagNumber(43)
  $core.String get outputContentRef => $_getSZ(12);
  @$pb.TagNumber(43)
  set outputContentRef($core.String v) {
    $_setString(12, v);
  }

  @$pb.TagNumber(43)
  $core.bool hasOutputContentRef() => $_has(12);
  @$pb.TagNumber(43)
  void clearOutputContentRef() => $_clearField(43);
}

/// Tool call information for agent/tool spans.
class ToolAttributes extends $pb.GeneratedMessage {
  factory ToolAttributes({
    $core.String? toolName,
    $core.String? toolInput,
    $core.String? toolOutput,
  }) {
    final $result = create();
    if (toolName != null) {
      $result.toolName = toolName;
    }
    if (toolInput != null) {
      $result.toolInput = toolInput;
    }
    if (toolOutput != null) {
      $result.toolOutput = toolOutput;
    }
    return $result;
  }
  ToolAttributes._() : super();
  factory ToolAttributes.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ToolAttributes.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ToolAttributes',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.types'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'toolName')
    ..aOS(2, _omitFieldNames ? '' : 'toolInput')
    ..aOS(3, _omitFieldNames ? '' : 'toolOutput')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolAttributes clone() => ToolAttributes()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ToolAttributes copyWith(void Function(ToolAttributes) updates) =>
      super.copyWith((message) => updates(message as ToolAttributes))
          as ToolAttributes;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ToolAttributes create() => ToolAttributes._();
  ToolAttributes createEmptyInstance() => create();
  static $pb.PbList<ToolAttributes> createRepeated() =>
      $pb.PbList<ToolAttributes>();
  @$core.pragma('dart2js:noInline')
  static ToolAttributes getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ToolAttributes>(create);
  static ToolAttributes? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get toolName => $_getSZ(0);
  @$pb.TagNumber(1)
  set toolName($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasToolName() => $_has(0);
  @$pb.TagNumber(1)
  void clearToolName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get toolInput => $_getSZ(1);
  @$pb.TagNumber(2)
  set toolInput($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasToolInput() => $_has(1);
  @$pb.TagNumber(2)
  void clearToolInput() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get toolOutput => $_getSZ(2);
  @$pb.TagNumber(3)
  set toolOutput($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasToolOutput() => $_has(2);
  @$pb.TagNumber(3)
  void clearToolOutput() => $_clearField(3);
}

/// A single span within a trace.
class Span extends $pb.GeneratedMessage {
  factory Span({
    $core.String? spanId,
    $core.String? traceId,
    $core.String? parentSpanId,
    $core.String? name,
    SpanKind? kind,
    SpanStatus? status,
    $core.String? statusMessage,
    $2.Timestamp? startTime,
    $2.Timestamp? endTime,
    $0.Duration? duration,
    GenAIAttributes? genAi,
    ToolAttributes? tool,
    $core.Iterable<$4.Attribute>? attributes,
    $core.String? projectId,
    $core.String? environment,
    $core.String? serviceName,
    $core.String? userId,
    $core.String? sessionId,
    $core.String? tenantId,
    $core.String? jobId,
    $core.String? traceGroup,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? labels,
    $core.Iterable<SpanEvent>? events,
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
    if (duration != null) {
      $result.duration = duration;
    }
    if (genAi != null) {
      $result.genAi = genAi;
    }
    if (tool != null) {
      $result.tool = tool;
    }
    if (attributes != null) {
      $result.attributes.addAll(attributes);
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
    if (labels != null) {
      $result.labels.addEntries(labels);
    }
    if (events != null) {
      $result.events.addAll(events);
    }
    return $result;
  }
  Span._() : super();
  factory Span.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Span.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Span',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.types'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'spanId')
    ..aOS(2, _omitFieldNames ? '' : 'traceId')
    ..aOS(3, _omitFieldNames ? '' : 'parentSpanId')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..e<SpanKind>(5, _omitFieldNames ? '' : 'kind', $pb.PbFieldType.OE,
        defaultOrMaker: SpanKind.SPAN_KIND_UNSPECIFIED,
        valueOf: SpanKind.valueOf,
        enumValues: SpanKind.values)
    ..e<SpanStatus>(6, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE,
        defaultOrMaker: SpanStatus.SPAN_STATUS_UNSPECIFIED,
        valueOf: SpanStatus.valueOf,
        enumValues: SpanStatus.values)
    ..aOS(7, _omitFieldNames ? '' : 'statusMessage')
    ..aOM<$2.Timestamp>(10, _omitFieldNames ? '' : 'startTime',
        subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(11, _omitFieldNames ? '' : 'endTime',
        subBuilder: $2.Timestamp.create)
    ..aOM<$0.Duration>(12, _omitFieldNames ? '' : 'duration',
        subBuilder: $0.Duration.create)
    ..aOM<GenAIAttributes>(20, _omitFieldNames ? '' : 'genAi',
        subBuilder: GenAIAttributes.create)
    ..aOM<ToolAttributes>(21, _omitFieldNames ? '' : 'tool',
        subBuilder: ToolAttributes.create)
    ..pc<$4.Attribute>(
        30, _omitFieldNames ? '' : 'attributes', $pb.PbFieldType.PM,
        subBuilder: $4.Attribute.create)
    ..aOS(40, _omitFieldNames ? '' : 'projectId')
    ..aOS(41, _omitFieldNames ? '' : 'environment')
    ..aOS(42, _omitFieldNames ? '' : 'serviceName')
    ..aOS(43, _omitFieldNames ? '' : 'userId')
    ..aOS(44, _omitFieldNames ? '' : 'sessionId')
    ..aOS(45, _omitFieldNames ? '' : 'tenantId')
    ..aOS(46, _omitFieldNames ? '' : 'jobId')
    ..aOS(47, _omitFieldNames ? '' : 'traceGroup')
    ..m<$core.String, $core.String>(48, _omitFieldNames ? '' : 'labels',
        entryClassName: 'Span.LabelsEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('candela.types'))
    ..pc<SpanEvent>(50, _omitFieldNames ? '' : 'events', $pb.PbFieldType.PM,
        subBuilder: SpanEvent.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Span clone() => Span()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Span copyWith(void Function(Span) updates) =>
      super.copyWith((message) => updates(message as Span)) as Span;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Span create() => Span._();
  Span createEmptyInstance() => create();
  static $pb.PbList<Span> createRepeated() => $pb.PbList<Span>();
  @$core.pragma('dart2js:noInline')
  static Span getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Span>(create);
  static Span? _defaultInstance;

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

  @$pb.TagNumber(5)
  SpanKind get kind => $_getN(4);
  @$pb.TagNumber(5)
  set kind(SpanKind v) {
    $_setField(5, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasKind() => $_has(4);
  @$pb.TagNumber(5)
  void clearKind() => $_clearField(5);

  @$pb.TagNumber(6)
  SpanStatus get status => $_getN(5);
  @$pb.TagNumber(6)
  set status(SpanStatus v) {
    $_setField(6, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

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

  @$pb.TagNumber(12)
  $0.Duration get duration => $_getN(9);
  @$pb.TagNumber(12)
  set duration($0.Duration v) {
    $_setField(12, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasDuration() => $_has(9);
  @$pb.TagNumber(12)
  void clearDuration() => $_clearField(12);
  @$pb.TagNumber(12)
  $0.Duration ensureDuration() => $_ensure(9);

  /// GenAI-specific attributes (populated for LLM/agent/tool/retrieval spans)
  @$pb.TagNumber(20)
  GenAIAttributes get genAi => $_getN(10);
  @$pb.TagNumber(20)
  set genAi(GenAIAttributes v) {
    $_setField(20, v);
  }

  @$pb.TagNumber(20)
  $core.bool hasGenAi() => $_has(10);
  @$pb.TagNumber(20)
  void clearGenAi() => $_clearField(20);
  @$pb.TagNumber(20)
  GenAIAttributes ensureGenAi() => $_ensure(10);

  /// Tool-specific attributes
  @$pb.TagNumber(21)
  ToolAttributes get tool => $_getN(11);
  @$pb.TagNumber(21)
  set tool(ToolAttributes v) {
    $_setField(21, v);
  }

  @$pb.TagNumber(21)
  $core.bool hasTool() => $_has(11);
  @$pb.TagNumber(21)
  void clearTool() => $_clearField(21);
  @$pb.TagNumber(21)
  ToolAttributes ensureTool() => $_ensure(11);

  /// General attributes from OTel
  @$pb.TagNumber(30)
  $pb.PbList<$4.Attribute> get attributes => $_getList(12);

  /// Metadata
  @$pb.TagNumber(40)
  $core.String get projectId => $_getSZ(13);
  @$pb.TagNumber(40)
  set projectId($core.String v) {
    $_setString(13, v);
  }

  @$pb.TagNumber(40)
  $core.bool hasProjectId() => $_has(13);
  @$pb.TagNumber(40)
  void clearProjectId() => $_clearField(40);

  @$pb.TagNumber(41)
  $core.String get environment => $_getSZ(14);
  @$pb.TagNumber(41)
  set environment($core.String v) {
    $_setString(14, v);
  }

  @$pb.TagNumber(41)
  $core.bool hasEnvironment() => $_has(14);
  @$pb.TagNumber(41)
  void clearEnvironment() => $_clearField(41);

  @$pb.TagNumber(42)
  $core.String get serviceName => $_getSZ(15);
  @$pb.TagNumber(42)
  set serviceName($core.String v) {
    $_setString(15, v);
  }

  @$pb.TagNumber(42)
  $core.bool hasServiceName() => $_has(15);
  @$pb.TagNumber(42)
  void clearServiceName() => $_clearField(42);

  @$pb.TagNumber(43)
  $core.String get userId => $_getSZ(16);
  @$pb.TagNumber(43)
  set userId($core.String v) {
    $_setString(16, v);
  }

  @$pb.TagNumber(43)
  $core.bool hasUserId() => $_has(16);
  @$pb.TagNumber(43)
  void clearUserId() => $_clearField(43);

  /// Conversation/session identifier for grouping related proxy calls.
  /// Set via X-Session-Id header by candela-local.
  @$pb.TagNumber(44)
  $core.String get sessionId => $_getSZ(17);
  @$pb.TagNumber(44)
  set sessionId($core.String v) {
    $_setString(17, v);
  }

  @$pb.TagNumber(44)
  $core.bool hasSessionId() => $_has(17);
  @$pb.TagNumber(44)
  void clearSessionId() => $_clearField(44);

  /// Downstream customer/tenant for multitenant cost attribution.
  /// Set via X-Candela-Tenant-Id header or W3C Baggage (candela.tenant_id).
  @$pb.TagNumber(45)
  $core.String get tenantId => $_getSZ(18);
  @$pb.TagNumber(45)
  set tenantId($core.String v) {
    $_setString(18, v);
  }

  @$pb.TagNumber(45)
  $core.bool hasTenantId() => $_has(18);
  @$pb.TagNumber(45)
  void clearTenantId() => $_clearField(45);

  /// Job/experiment/workflow identifier for cost attribution and A/B grouping.
  /// Set via X-Candela-Job header or W3C Baggage (candela.job_id).
  @$pb.TagNumber(46)
  $core.String get jobId => $_getSZ(19);
  @$pb.TagNumber(46)
  set jobId($core.String v) {
    $_setString(19, v);
  }

  @$pb.TagNumber(46)
  $core.bool hasJobId() => $_has(19);
  @$pb.TagNumber(46)
  void clearJobId() => $_clearField(46);

  /// Logical trace group for correlating multi-step agent sessions.
  /// All proxy calls within one agent run share this ID.
  /// Set via X-Candela-Trace-Group header or W3C Baggage (candela.trace_group).
  @$pb.TagNumber(47)
  $core.String get traceGroup => $_getSZ(20);
  @$pb.TagNumber(47)
  set traceGroup($core.String v) {
    $_setString(20, v);
  }

  @$pb.TagNumber(47)
  $core.bool hasTraceGroup() => $_has(20);
  @$pb.TagNumber(47)
  void clearTraceGroup() => $_clearField(47);

  /// Arbitrary user-defined key-value labels for custom filtering.
  /// Set via X-Candela-Labels header (comma-separated k=v pairs).
  @$pb.TagNumber(48)
  $pb.PbMap<$core.String, $core.String> get labels => $_getMap(21);

  /// Events (OTel span events)
  @$pb.TagNumber(50)
  $pb.PbList<SpanEvent> get events => $_getList(22);
}

/// An event attached to a span.
class SpanEvent extends $pb.GeneratedMessage {
  factory SpanEvent({
    $core.String? name,
    $2.Timestamp? timestamp,
    $core.Iterable<$4.Attribute>? attributes,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    if (timestamp != null) {
      $result.timestamp = timestamp;
    }
    if (attributes != null) {
      $result.attributes.addAll(attributes);
    }
    return $result;
  }
  SpanEvent._() : super();
  factory SpanEvent.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SpanEvent.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SpanEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.types'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOM<$2.Timestamp>(2, _omitFieldNames ? '' : 'timestamp',
        subBuilder: $2.Timestamp.create)
    ..pc<$4.Attribute>(
        3, _omitFieldNames ? '' : 'attributes', $pb.PbFieldType.PM,
        subBuilder: $4.Attribute.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpanEvent clone() => SpanEvent()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SpanEvent copyWith(void Function(SpanEvent) updates) =>
      super.copyWith((message) => updates(message as SpanEvent)) as SpanEvent;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SpanEvent create() => SpanEvent._();
  SpanEvent createEmptyInstance() => create();
  static $pb.PbList<SpanEvent> createRepeated() => $pb.PbList<SpanEvent>();
  @$core.pragma('dart2js:noInline')
  static SpanEvent getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SpanEvent>(create);
  static SpanEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.Timestamp get timestamp => $_getN(1);
  @$pb.TagNumber(2)
  set timestamp($2.Timestamp v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Timestamp ensureTimestamp() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<$4.Attribute> get attributes => $_getList(2);
}

/// A complete trace consisting of multiple spans.
class Trace extends $pb.GeneratedMessage {
  factory Trace({
    $core.String? traceId,
    $2.Timestamp? startTime,
    $2.Timestamp? endTime,
    $0.Duration? duration,
    $core.String? projectId,
    $core.String? environment,
    $core.int? spanCount,
    $fixnum.Int64? totalTokens,
    $core.double? totalCostUsd,
    $core.String? rootSpanName,
    $core.String? userId,
    $core.String? sessionId,
    $core.String? tenantId,
    $core.String? jobId,
    $core.String? traceGroup,
    $core.Iterable<Span>? spans,
  }) {
    final $result = create();
    if (traceId != null) {
      $result.traceId = traceId;
    }
    if (startTime != null) {
      $result.startTime = startTime;
    }
    if (endTime != null) {
      $result.endTime = endTime;
    }
    if (duration != null) {
      $result.duration = duration;
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (environment != null) {
      $result.environment = environment;
    }
    if (spanCount != null) {
      $result.spanCount = spanCount;
    }
    if (totalTokens != null) {
      $result.totalTokens = totalTokens;
    }
    if (totalCostUsd != null) {
      $result.totalCostUsd = totalCostUsd;
    }
    if (rootSpanName != null) {
      $result.rootSpanName = rootSpanName;
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
    if (spans != null) {
      $result.spans.addAll(spans);
    }
    return $result;
  }
  Trace._() : super();
  factory Trace.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Trace.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Trace',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.types'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'traceId')
    ..aOM<$2.Timestamp>(2, _omitFieldNames ? '' : 'startTime',
        subBuilder: $2.Timestamp.create)
    ..aOM<$2.Timestamp>(3, _omitFieldNames ? '' : 'endTime',
        subBuilder: $2.Timestamp.create)
    ..aOM<$0.Duration>(4, _omitFieldNames ? '' : 'duration',
        subBuilder: $0.Duration.create)
    ..aOS(5, _omitFieldNames ? '' : 'projectId')
    ..aOS(6, _omitFieldNames ? '' : 'environment')
    ..a<$core.int>(7, _omitFieldNames ? '' : 'spanCount', $pb.PbFieldType.O3)
    ..aInt64(8, _omitFieldNames ? '' : 'totalTokens')
    ..a<$core.double>(
        9, _omitFieldNames ? '' : 'totalCostUsd', $pb.PbFieldType.OD)
    ..aOS(10, _omitFieldNames ? '' : 'rootSpanName')
    ..aOS(11, _omitFieldNames ? '' : 'userId')
    ..aOS(12, _omitFieldNames ? '' : 'sessionId')
    ..aOS(13, _omitFieldNames ? '' : 'tenantId')
    ..aOS(14, _omitFieldNames ? '' : 'jobId')
    ..aOS(15, _omitFieldNames ? '' : 'traceGroup')
    ..pc<Span>(20, _omitFieldNames ? '' : 'spans', $pb.PbFieldType.PM,
        subBuilder: Span.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Trace clone() => Trace()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Trace copyWith(void Function(Trace) updates) =>
      super.copyWith((message) => updates(message as Trace)) as Trace;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Trace create() => Trace._();
  Trace createEmptyInstance() => create();
  static $pb.PbList<Trace> createRepeated() => $pb.PbList<Trace>();
  @$core.pragma('dart2js:noInline')
  static Trace getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Trace>(create);
  static Trace? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get traceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set traceId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTraceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTraceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.Timestamp get startTime => $_getN(1);
  @$pb.TagNumber(2)
  set startTime($2.Timestamp v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasStartTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartTime() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Timestamp ensureStartTime() => $_ensure(1);

  @$pb.TagNumber(3)
  $2.Timestamp get endTime => $_getN(2);
  @$pb.TagNumber(3)
  set endTime($2.Timestamp v) {
    $_setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasEndTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearEndTime() => $_clearField(3);
  @$pb.TagNumber(3)
  $2.Timestamp ensureEndTime() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Duration get duration => $_getN(3);
  @$pb.TagNumber(4)
  set duration($0.Duration v) {
    $_setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasDuration() => $_has(3);
  @$pb.TagNumber(4)
  void clearDuration() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Duration ensureDuration() => $_ensure(3);

  /// Aggregated metadata
  @$pb.TagNumber(5)
  $core.String get projectId => $_getSZ(4);
  @$pb.TagNumber(5)
  set projectId($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasProjectId() => $_has(4);
  @$pb.TagNumber(5)
  void clearProjectId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get environment => $_getSZ(5);
  @$pb.TagNumber(6)
  set environment($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasEnvironment() => $_has(5);
  @$pb.TagNumber(6)
  void clearEnvironment() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.int get spanCount => $_getIZ(6);
  @$pb.TagNumber(7)
  set spanCount($core.int v) {
    $_setSignedInt32(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasSpanCount() => $_has(6);
  @$pb.TagNumber(7)
  void clearSpanCount() => $_clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get totalTokens => $_getI64(7);
  @$pb.TagNumber(8)
  set totalTokens($fixnum.Int64 v) {
    $_setInt64(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasTotalTokens() => $_has(7);
  @$pb.TagNumber(8)
  void clearTotalTokens() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get totalCostUsd => $_getN(8);
  @$pb.TagNumber(9)
  set totalCostUsd($core.double v) {
    $_setDouble(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasTotalCostUsd() => $_has(8);
  @$pb.TagNumber(9)
  void clearTotalCostUsd() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.String get rootSpanName => $_getSZ(9);
  @$pb.TagNumber(10)
  set rootSpanName($core.String v) {
    $_setString(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasRootSpanName() => $_has(9);
  @$pb.TagNumber(10)
  void clearRootSpanName() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.String get userId => $_getSZ(10);
  @$pb.TagNumber(11)
  set userId($core.String v) {
    $_setString(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasUserId() => $_has(10);
  @$pb.TagNumber(11)
  void clearUserId() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.String get sessionId => $_getSZ(11);
  @$pb.TagNumber(12)
  set sessionId($core.String v) {
    $_setString(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasSessionId() => $_has(11);
  @$pb.TagNumber(12)
  void clearSessionId() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get tenantId => $_getSZ(12);
  @$pb.TagNumber(13)
  set tenantId($core.String v) {
    $_setString(12, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasTenantId() => $_has(12);
  @$pb.TagNumber(13)
  void clearTenantId() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get jobId => $_getSZ(13);
  @$pb.TagNumber(14)
  set jobId($core.String v) {
    $_setString(13, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasJobId() => $_has(13);
  @$pb.TagNumber(14)
  void clearJobId() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get traceGroup => $_getSZ(14);
  @$pb.TagNumber(15)
  set traceGroup($core.String v) {
    $_setString(14, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasTraceGroup() => $_has(14);
  @$pb.TagNumber(15)
  void clearTraceGroup() => $_clearField(15);

  /// All spans in the trace
  @$pb.TagNumber(20)
  $pb.PbList<Span> get spans => $_getList(15);
}

/// Summary metrics for a trace (used in list views).
class TraceSummary extends $pb.GeneratedMessage {
  factory TraceSummary({
    $core.String? traceId,
    $2.Timestamp? startTime,
    $0.Duration? duration,
    $core.String? rootSpanName,
    $core.String? projectId,
    $core.String? environment,
    $core.int? spanCount,
    $core.int? llmCallCount,
    $fixnum.Int64? totalTokens,
    $core.double? totalCostUsd,
    SpanStatus? status,
    $core.String? primaryModel,
    $core.String? primaryProvider,
    $core.String? userId,
    $core.String? sessionId,
    $core.String? tenantId,
    $core.String? jobId,
    $core.String? traceGroup,
  }) {
    final $result = create();
    if (traceId != null) {
      $result.traceId = traceId;
    }
    if (startTime != null) {
      $result.startTime = startTime;
    }
    if (duration != null) {
      $result.duration = duration;
    }
    if (rootSpanName != null) {
      $result.rootSpanName = rootSpanName;
    }
    if (projectId != null) {
      $result.projectId = projectId;
    }
    if (environment != null) {
      $result.environment = environment;
    }
    if (spanCount != null) {
      $result.spanCount = spanCount;
    }
    if (llmCallCount != null) {
      $result.llmCallCount = llmCallCount;
    }
    if (totalTokens != null) {
      $result.totalTokens = totalTokens;
    }
    if (totalCostUsd != null) {
      $result.totalCostUsd = totalCostUsd;
    }
    if (status != null) {
      $result.status = status;
    }
    if (primaryModel != null) {
      $result.primaryModel = primaryModel;
    }
    if (primaryProvider != null) {
      $result.primaryProvider = primaryProvider;
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
    return $result;
  }
  TraceSummary._() : super();
  factory TraceSummary.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory TraceSummary.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TraceSummary',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'candela.types'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'traceId')
    ..aOM<$2.Timestamp>(2, _omitFieldNames ? '' : 'startTime',
        subBuilder: $2.Timestamp.create)
    ..aOM<$0.Duration>(3, _omitFieldNames ? '' : 'duration',
        subBuilder: $0.Duration.create)
    ..aOS(4, _omitFieldNames ? '' : 'rootSpanName')
    ..aOS(5, _omitFieldNames ? '' : 'projectId')
    ..aOS(6, _omitFieldNames ? '' : 'environment')
    ..a<$core.int>(10, _omitFieldNames ? '' : 'spanCount', $pb.PbFieldType.O3)
    ..a<$core.int>(
        11, _omitFieldNames ? '' : 'llmCallCount', $pb.PbFieldType.O3)
    ..aInt64(12, _omitFieldNames ? '' : 'totalTokens')
    ..a<$core.double>(
        13, _omitFieldNames ? '' : 'totalCostUsd', $pb.PbFieldType.OD)
    ..e<SpanStatus>(14, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE,
        defaultOrMaker: SpanStatus.SPAN_STATUS_UNSPECIFIED,
        valueOf: SpanStatus.valueOf,
        enumValues: SpanStatus.values)
    ..aOS(15, _omitFieldNames ? '' : 'primaryModel')
    ..aOS(16, _omitFieldNames ? '' : 'primaryProvider')
    ..aOS(17, _omitFieldNames ? '' : 'userId')
    ..aOS(18, _omitFieldNames ? '' : 'sessionId')
    ..aOS(19, _omitFieldNames ? '' : 'tenantId')
    ..aOS(20, _omitFieldNames ? '' : 'jobId')
    ..aOS(21, _omitFieldNames ? '' : 'traceGroup')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TraceSummary clone() => TraceSummary()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TraceSummary copyWith(void Function(TraceSummary) updates) =>
      super.copyWith((message) => updates(message as TraceSummary))
          as TraceSummary;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TraceSummary create() => TraceSummary._();
  TraceSummary createEmptyInstance() => create();
  static $pb.PbList<TraceSummary> createRepeated() =>
      $pb.PbList<TraceSummary>();
  @$core.pragma('dart2js:noInline')
  static TraceSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TraceSummary>(create);
  static TraceSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get traceId => $_getSZ(0);
  @$pb.TagNumber(1)
  set traceId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTraceId() => $_has(0);
  @$pb.TagNumber(1)
  void clearTraceId() => $_clearField(1);

  @$pb.TagNumber(2)
  $2.Timestamp get startTime => $_getN(1);
  @$pb.TagNumber(2)
  set startTime($2.Timestamp v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasStartTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartTime() => $_clearField(2);
  @$pb.TagNumber(2)
  $2.Timestamp ensureStartTime() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Duration get duration => $_getN(2);
  @$pb.TagNumber(3)
  set duration($0.Duration v) {
    $_setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasDuration() => $_has(2);
  @$pb.TagNumber(3)
  void clearDuration() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Duration ensureDuration() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get rootSpanName => $_getSZ(3);
  @$pb.TagNumber(4)
  set rootSpanName($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasRootSpanName() => $_has(3);
  @$pb.TagNumber(4)
  void clearRootSpanName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get projectId => $_getSZ(4);
  @$pb.TagNumber(5)
  set projectId($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasProjectId() => $_has(4);
  @$pb.TagNumber(5)
  void clearProjectId() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get environment => $_getSZ(5);
  @$pb.TagNumber(6)
  set environment($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasEnvironment() => $_has(5);
  @$pb.TagNumber(6)
  void clearEnvironment() => $_clearField(6);

  @$pb.TagNumber(10)
  $core.int get spanCount => $_getIZ(6);
  @$pb.TagNumber(10)
  set spanCount($core.int v) {
    $_setSignedInt32(6, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasSpanCount() => $_has(6);
  @$pb.TagNumber(10)
  void clearSpanCount() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.int get llmCallCount => $_getIZ(7);
  @$pb.TagNumber(11)
  set llmCallCount($core.int v) {
    $_setSignedInt32(7, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasLlmCallCount() => $_has(7);
  @$pb.TagNumber(11)
  void clearLlmCallCount() => $_clearField(11);

  @$pb.TagNumber(12)
  $fixnum.Int64 get totalTokens => $_getI64(8);
  @$pb.TagNumber(12)
  set totalTokens($fixnum.Int64 v) {
    $_setInt64(8, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasTotalTokens() => $_has(8);
  @$pb.TagNumber(12)
  void clearTotalTokens() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.double get totalCostUsd => $_getN(9);
  @$pb.TagNumber(13)
  set totalCostUsd($core.double v) {
    $_setDouble(9, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasTotalCostUsd() => $_has(9);
  @$pb.TagNumber(13)
  void clearTotalCostUsd() => $_clearField(13);

  @$pb.TagNumber(14)
  SpanStatus get status => $_getN(10);
  @$pb.TagNumber(14)
  set status(SpanStatus v) {
    $_setField(14, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasStatus() => $_has(10);
  @$pb.TagNumber(14)
  void clearStatus() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get primaryModel => $_getSZ(11);
  @$pb.TagNumber(15)
  set primaryModel($core.String v) {
    $_setString(11, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasPrimaryModel() => $_has(11);
  @$pb.TagNumber(15)
  void clearPrimaryModel() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get primaryProvider => $_getSZ(12);
  @$pb.TagNumber(16)
  set primaryProvider($core.String v) {
    $_setString(12, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasPrimaryProvider() => $_has(12);
  @$pb.TagNumber(16)
  void clearPrimaryProvider() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get userId => $_getSZ(13);
  @$pb.TagNumber(17)
  set userId($core.String v) {
    $_setString(13, v);
  }

  @$pb.TagNumber(17)
  $core.bool hasUserId() => $_has(13);
  @$pb.TagNumber(17)
  void clearUserId() => $_clearField(17);

  @$pb.TagNumber(18)
  $core.String get sessionId => $_getSZ(14);
  @$pb.TagNumber(18)
  set sessionId($core.String v) {
    $_setString(14, v);
  }

  @$pb.TagNumber(18)
  $core.bool hasSessionId() => $_has(14);
  @$pb.TagNumber(18)
  void clearSessionId() => $_clearField(18);

  @$pb.TagNumber(19)
  $core.String get tenantId => $_getSZ(15);
  @$pb.TagNumber(19)
  set tenantId($core.String v) {
    $_setString(15, v);
  }

  @$pb.TagNumber(19)
  $core.bool hasTenantId() => $_has(15);
  @$pb.TagNumber(19)
  void clearTenantId() => $_clearField(19);

  @$pb.TagNumber(20)
  $core.String get jobId => $_getSZ(16);
  @$pb.TagNumber(20)
  set jobId($core.String v) {
    $_setString(16, v);
  }

  @$pb.TagNumber(20)
  $core.bool hasJobId() => $_has(16);
  @$pb.TagNumber(20)
  void clearJobId() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.String get traceGroup => $_getSZ(17);
  @$pb.TagNumber(21)
  set traceGroup($core.String v) {
    $_setString(17, v);
  }

  @$pb.TagNumber(21)
  $core.bool hasTraceGroup() => $_has(17);
  @$pb.TagNumber(21)
  void clearTraceGroup() => $_clearField(21);
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
