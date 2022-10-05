unit Tensorflow;

{$WARN IMPLICIT_STRING_CAST OFF}
{$WARN IMPLICIT_STRING_CAST_LOSS OFF}

interface
  uses System.SysUtils, System.Rtti,  System.TypInfo,
       quick.Logger,
       System.Generics.Collections,
       Spring.Collections.Dictionaries,
       Spring.Collections.Extensions,
       Spring.Collections.Stacks,
       Spring,
       Quick.Logger.Provider.Files,

       TF4D.Core.CApi,
       TensorFlow.DApiBase,
       TensorFlow.DApi,
       TensorFlow.Context,
       TensorFlow.EagareRunner,
       TensorFlow.DApiEager,
       Tensorflow.Utils,
       TensorFlow.OpDefLibrary,
       Tensorflow.Gradient,
       Tensorflow.Session,
       Tensorflow.String_ops,
       TensorFlow.Variable,

       ProtoGen.Tensor,
       Protogen.tensorShape,
       ProtoGen.attrValue,
       ProtoGen.types,
       ProtoGen.opDef,
       protogen.config;



const
  C_GRAPH_MODE : Integer = 0;
  C_EAGER_MODE : Integer = 1;

type
{$REGION 'CompatV1Api'}
  CompatV1Api = class
     private

     public
       constructor Create;
       destructor  Destroy; override;
       procedure disable_eager_execution;
       function  Session: TFSession;
       function global_variables_initializer: TFOperation;
  end;
{$ENDREGION}

{$REGION 'CompatApi'}
  CompatApi = class
     public
       v1 : CompatV1Api;

       constructor Create;
       destructor  Destroy; override;
  end;
{$ENDREGION}

{$REGION 'StringsApi'}
  StringsApi = class
    private

    public
      ops : string_ops;
      /// <summary>
      /// Converts all uppercase characters into their respective lowercase replacements.
      /// </summary>
      /// <param name="input"></param>
      /// <param name="encoding"></param>
      /// <param name="name"></param>
      /// <returns></returns>
      function lower(input: TFTensor; encoding: string = ''; name : string = ''): TFTensor;
      /// <summary>
      ///
      /// </summary>
      /// <param name="input"></param>
      /// <param name="pattern"></param>
      /// <param name="rewrite"></param>
      /// <param name="replace_global"></param>
      /// <param name="name"></param>
      /// <returns></returns>
      function regex_replace(input: TFTensor; pattern: string; rewrite: string; replace_global: Boolean = true; name : string = ''): TFTensor;
      /// <summary>
      /// Return substrings from `Tensor` of strings.
      /// </summary>
      /// <param name="input"></param>
      /// <param name="pos"></param>
      /// <param name="len"></param>
      /// <param name="name"></param>
      /// <param name="uint"></param>
      /// <returns></returns>
      function substr(input: TFTensor; pos: Integer; len: Integer; name: string  = ''; &uint: string = 'BYTE'): TFTensor; overload;
      function substr(input: String; pos: Integer; len: Integer; name: string = ''; &uint: string = 'BYTE'): TFTensor;overload;
  end;
{$ENDREGION}

{$REGION 'GraphKeys'}
  /// <summary>
  /// Standard names to use for graph collections.
  /// The standard library uses various well-known names to collect and
  /// retrieve values associated with a graph. For example, the
  /// `tf.Optimizer` subclasses default to optimizing the variables
  /// collected under `tf.GraphKeys.TRAINABLE_VARIABLES` if none is
  /// specified, but it is also possible to pass an explicit list of
  /// variables.
  /// </summary>
  TGraphKeys = record
    public
    const
      /// <summary>
      /// Key to collect concatenated sharded variables.
      /// </summary>
      CONCATENATED_VARIABLES_      :  string  = 'concatenated_variables';
      /// <summary>
      /// the subset of `Variable` objects that will be trained by an optimizer.
      /// </summary>
      TRAINABLE_VARIABLES_         :  string  = 'trainable_variables';
      /// <summary>
      /// Trainable resource-style variables.
      /// </summary>
      TRAINABLE_RESOURCE_VARIABLES_:  string  = 'trainable_resource_variables';
      /// <summary>
      /// Key for streaming model ports.
      /// </summary>
      _STREAMING_MODEL_PORTS_      :  string  = 'streaming_model_ports';
      /// <summary>
      /// Key to collect losses
      /// </summary>
      LOSSES_                      :  string  = 'losses';
      LOCAL_VARIABLES_             :  string  = 'local_variables';
      METRIC_VARIABLES_            :  string  = 'metric_variables';
      MODEL_VARIABLES_             :  string  = 'model_variables';
      MOVING_AVERAGE_VARIABLES_    :  string  = 'moving_average_variables';
      /// <summary>
      /// Key to collect Variable objects that are global (shared across machines).
      /// Default collection for all variables, except local ones.
      /// </summary>
      GLOBAL_VARIABLES_ :  string  = 'variables';
      TRAIN_OP_         :  string  = 'train_op';
      GLOBAL_STEP_      :  string  = 'global_step';
      /// <summary>
      /// List of all collections that keep track of variables.
      /// </summary>
      _VARIABLE_COLLECTIONS_ : Array[0..7] of string = (
          'variables',
          'local_variables',
          'metric_variables',
          'model_variables',
          'trainable_variables',
          'moving_average_variables',
          'concatenated_variables',
          'trainable_resource_variables');
      /// <summary>
      /// Key to collect BaseSaverBuilder.SaveableObject instances for checkpointing.
      /// </summary>
      SAVEABLE_OBJECTS_     :  string = 'saveable_objects';
      /// <summary>
      /// Key to collect update_ops
      /// </summary>
      UPDATE_OPS_           :  string = 'update_ops';
      // Key to collect summaries.
      SUMMARIES_            :  string = 'summaries';
      // Used to store v2 summary names.
      _SUMMARY_COLLECTION_  :  string = '_SUMMARY_V2';
      // Key for control flow context.
      COND_CONTEXT_         :  string = 'cond_context';
      WHILE_CONTEXT_        :  string = 'while_context';
    class var
      CONCATENATED_VARIABLES : String;
      /// <summary>
      /// the subset of `Variable` objects that will be trained by an optimizer.
      /// </summary>
      TRAINABLE_VARIABLES : String;
      /// <summary>
      /// Trainable resource-style variables.
      /// </summary>
      TRAINABLE_RESOURCE_VARIABLES : String;
      /// <summary>
      /// Key for streaming model ports.
      /// </summary>
      _STREAMING_MODEL_PORTS : String;
      /// <summary>
      /// Key to collect local variables that are local to the machine and are not
      /// saved/restored.
      /// </summary>
      LOCAL_VARIABLES : String;
      /// <summary>
      /// Key to collect losses
      /// </summary>
      LOSSES : String;
      METRIC_VARIABLES : String;
      MOVING_AVERAGE_VARIABLES : string;
      /// <summary>
      /// Key to collect Variable objects that are global (shared across machines).
      /// Default collection for all variables, except local ones.
      /// </summary>
      GLOBAL_VARIABLES : String;
      TRAIN_OP : String;
      GLOBAL_STEP : String;
      GLOBAL_STEP_READ_KEY : string;
      _VARIABLE_COLLECTIONS : TArray<string>;
      /// <summary>
      /// Key to collect BaseSaverBuilder.SaveableObject instances for checkpointing.
      /// </summary>
      SAVEABLE_OBJECTS : String;
      /// <summary>
      /// Key to collect update_ops
      /// </summary>
      UPDATE_OPS : String;
      // Key to collect summaries.
      SUMMARIES : String;
      // Used to store v2 summary names.
      _SUMMARY_COLLECTION : String;
      // Key for control flow context.
      COND_CONTEXT : String;
      WHILE_CONTEXT : String;
      class function Create: TGraphKeys; static;
  end;
{$ENDREGION}

{$REGION 'TTensorflow'}
  TTensorflow = class(TFDisposable)
    private
      FtapeSet : TGradientTape;
      function GetVersion: string;
    protected
		  procedure NativeDispose(hnd: Pointer); override;

    public
     const
      byte8_t   = TF_DataType.TF_UINT8;
      int8_t    = TF_DataType.TF_INT8;
      int16_t   = TF_DataType.TF_INT16;
      int32_t   = TF_DataType.TF_INT32;
      int64_t   = TF_DataType.TF_INT64;
      float16_t = TF_DataType.TF_HALF;
      float32_  = TF_DataType.TF_FLOAT;
      float64_t = TF_DataType.TF_DOUBLE;
      bool_t    = TF_DataType.TF_BOOL;
      chars_t   = TF_DataType.TF_STRING;
      string_t  = TF_DataType.TF_STRING;
     var
      Status   : TFStatus;
      Context  : TContext;
      OpDefLib : OpDefLibrary;
      Runner   : TEagerRunner;
      compat   : CompatApi;
      strings  : StringsApi;
      GraphKeys: TGraphKeys;

      constructor Create;
      destructor  Destroy ; override;
      procedure   enable_eager_execution;
      function    executing_eagerly:Boolean;
      function    get_default_graph: TFgraph;
      procedure   reset_default_graph;
      function    peak_default_graph: TFgraph;

      function convert_to_tensor(value: TValue; dtype: TF_DataType= DtInvalid; name: string= ''; preferred_dtype: TF_DataType=DtInvalid): TFTensor;
      function placeholder(dtype: TF_DataType; shape: TFShape ; name: string = ''): TFTensor;

      function  zeros(shape: TFShape; dtype:  TF_DataType = TF_DataType.TF_FLOAT; name: string = ''): TFTensor; overload;
      function  zeros(shape: TFTensor; dtype: TF_DataType = TF_DataType.TF_FLOAT; name: string = ''): TFTensor; overload;
      function  ones(shape: TFShape; dtype: TF_DataType = TF_DataType.TF_FLOAT; name: string = ''): TFTensor;
      function  size(input: TFTensor; name: string = ''; out_type: TF_DataType = TF_DataType.TF_INT32): TFTensor;
      function  reshape(tensor: TFTensor; shape: TFShape; name: string = ''): TFTensor;

      /// <summary>
      ///
      /// </summary>
      /// <param name="value"></param>
      /// <param name="dtype"></param>
      /// <param name="shape"></param>
      /// <param name="name"></param>
      /// <returns></returns>
      function constant(value: TValue; dtype : TF_DataType = DtInvalid; shape : PTFShape= nil; name : AnsiString = 'Const'): TFTensor;
      /// <summary>
      ///     Creates a new graph.
      /// </summary>
      ///<remarks>Has no interaction with graph defaulting. Equivalent to new Graph();</remarks>
      function Graph: TFGraph;

      property Version : string read GetVersion;
      // Gradient
      /// <summary>
      /// Record operations for automatic differentiation.
      /// </summary>
      /// <param name="persistent"></param>
      /// <param name="watch_accessed_variables"></param>
      /// <returns>Tape set</returns>
      function GradientTape(persistent: Boolean = false; watch_accessed_variables: Boolean = true): TGradientTape;
      function GetTapeSet: TStack<ITape>;
      function Session(graph: TFGraph; config: PConfigProto = nil): TFSession;overload;
      function Session: TFSession;overload;
      function get_default_session: TFSession;
      function global_variables_initializer: TFOperation;
      /// <summary>
      /// Returns an Op that initializes a list of variables.
      /// </summary>
      /// <param name="var_list">List of `Variable` objects to initialize.</param>
      /// <param name="name">Optional name for the returned operation.</param>
      /// <returns>An Op that run the initializers of all the specified variables.</returns>
      function variables_initializer(var_list: TArray<IVariableV1>; name : string= 'init'):TFOperation;
      function global_variables(scope: string = '') : TArray<IVariableV1>;
      function trainable_variables(scope: string = '') : TArray<IVariableV1>;
  end;
{$ENDREGION}

  var
   tf : TTensorflow;

implementation
   uses Oz.Pb.Classes, Oz.SGL.Collections,oz.Pb.StrBuffer, pbPublic, pbInput, pbOutput,
        NumPy.NDArray,
        TensorFlow.EagerTensor,
        TensorFlow.Ops ,
        TensorFlow.Constant_op,
        Tensorflow.gen_array_ops,
        Tensorflow.array_ops,
        Numpy.Axis;

{$REGION 'TTensorflow'}
{ TTensorflow }

function TTensorflow.convert_to_tensor(value: TValue; dtype: TF_DataType; name: string; preferred_dtype: TF_DataType): TFTensor;
begin
    Result := TOps.convert_to_tensor(value,dtype, name,False,preferred_dtype);
end;


function TTensorflow.constant(value: TValue; dtype: TF_DataType; shape: PTFShape; name: AnsiString): TFTensor;
begin
    Result :=constant_op.constant(@value,
                                    dtype,
                                    shape,
                                    False,
                                    True,
                                    name);
end;

constructor TTensorflow.Create;
begin
    Context   := TContext.Create;
    Status    := TFStatus.Create;
    OpDefLib  := OpDefLibrary.Create;
    runner    := TEagerRunner.Create ;
    FtapeSet  := TGradientTape.Create;
    compat    := CompatApi.Create;
    strings   := StringsApi.Create;
    GraphKeys := TGraphKeys.Create;

    Logger.Providers.Add(GlobalLogFileProvider);
    with GlobalLogFileProvider do
    begin
      FileName := '.\Logs.log';
      LogLevel := LOG_ALL;
      TimePrecission := True;
      MaxRotateFiles := 3;
      MaxFileSizeInMB := 5;
      RotatedFilesPath := '.\RotatedLogs';
      CompressRotatedFiles := False;
      Enabled := True;
    end;
end;

destructor TTensorflow.Destroy;
begin
  inherited;

  Context.Free;
  Status.Free;
  OpDefLib.Free;
  Runner.Free;
  FtapeSet.Free;
  compat.Free;
  strings.Free;

end;

procedure TTensorflow.enable_eager_execution;
begin
    Context.eager_mode;
end;

function TTensorflow.executing_eagerly: Boolean;
begin
    Result := Context.executing_eagerly;
end;

function TTensorflow.GetVersion: string;
begin
     Result := string(AnsiString(TF_Version));
end;

procedure TTensorflow.NativeDispose(hnd: Pointer);
begin
  inherited;

  Context.Free;
  Status.Free;
  OpDefLib.Free;
  Runner.Free;
  FtapeSet.Free;

end;

function TTensorflow.get_default_graph: TFgraph;
begin
    Result := TOps.get_default_graph;
end;

function TTensorflow.get_default_session: TFSession;
begin
    Result := Tops.get_default_session;
end;

function TTensorflow.global_variables(scope: string): TArray<IVariableV1>;
begin
    var Value := TOps.get_collection(tf.GraphKeys.GLOBAL_VARIABLES, scope) ;
    Result := Value.AsType< TList<IVariableV1> >.ToArray;
end;

function TTensorflow.global_variables_initializer: TFOperation;
begin
    Result := tf.compat.v1.global_variables_initializer;
end;

function TTensorflow.Graph: TFGraph;
begin
    Result := TFGraph.Create;
end;

function TTensorflow.peak_default_graph: TFgraph;
begin
    Result := TOps.peak_default_graph;
end;

function TTensorflow.placeholder(dtype: TF_DataType; shape: TFShape; name: string): TFTensor;
begin
    Result := array_ops.placeholder(dtype,@shape,name);
end;

procedure TTensorflow.reset_default_graph;
begin
    TOps.reset_default_graph
end;

function TTensorflow.reshape(tensor: TFTensor; shape: TFShape; name: string): TFTensor;
begin
    Result := gen_array_ops.reshape(tensor, shape, name);
end;

function TTensorflow.Session: TFSession;
begin
    Result := compat.v1.Session;
end;

function TTensorflow.Session(graph: TFGraph; config: PConfigProto): TFSession;
begin
    Result := TFSession.Create(graph, config).as_default;
end;

function TTensorflow.ones(shape: TFShape; dtype: TF_DataType; name: string): TFTensor;
begin
    Result := array_ops.ones(shape, dtype, name);
end;

function TTensorflow.size(input: TFTensor; name: string; out_type: TF_DataType): TFTensor;
begin
    Result := array_ops.size(input, name, true, out_type);
end;

function TTensorflow.trainable_variables(scope: string): TArray<IVariableV1>;
begin
    var Value := variables.trainable_variables;
    Result := Value.AsType< TList<IVariableV1> >.ToArray;
end;

function TTensorflow.variables_initializer(var_list: TArray<IVariableV1>; name: string): TFOperation;
begin
    Result := variables.variables_initializer(var_list, name)
end;

function TTensorflow.zeros(shape: TFShape; dtype: TF_DataType; name: string): TFTensor;
begin
    Result := array_ops.zeros(shape, dtype, name);
end;

function TTensorflow.zeros(shape: TFTensor; dtype: TF_DataType; name: string): TFTensor;
begin
    Result := array_ops.zeros(shape, dtype, name);
end;

function TTensorflow.GradientTape(persistent: Boolean = false; watch_accessed_variables: Boolean = true): TGradientTape;
begin
    var tape := FtapeSet.PushTape(persistent, watch_accessed_variables);
    tape.StartRecord;
    Result := FtapeSet;
end;

function TTensorflow.GetTapeSet: TStack<ITape>;
begin
    Result := FtapeSet.GetTapeSet;
end;
{$ENDREGION}

{$REGION 'CompatV1Api'}
{ CompatV1Api }

constructor CompatV1Api.Create;
begin
  inherited;

end;

destructor CompatV1Api.Destroy;
begin

  inherited;
end;

procedure CompatV1Api.disable_eager_execution;
begin
    tf.Context.graph_mode ;
end;

function CompatV1Api.global_variables_initializer: TFOperation;
begin
    var g := variables.global_variables;
    Result:= variables.variables_initializer(g.ToArray);
end;

function CompatV1Api.Session: TFSession;
begin
    Result := TFSession.Create;
    Result.as_default;
end;
{$ENDREGION}

{$REGION 'CompatApi'}
{ CompatApi }

constructor CompatApi.Create;
begin
  inherited Create;
  v1 := CompatV1Api.Create;
end;

destructor CompatApi.Destroy;
begin
  v1.Free;
  inherited;
end;
{$ENDREGION}

{$REGION 'StringsApi'}
{ StringsApi }

function StringsApi.lower(input: TFTensor; encoding, name: string): TFTensor;
begin
    Result := ops.lower(input, encoding, name);
end;

function StringsApi.regex_replace(input: TFTensor; pattern, rewrite: string; replace_global: Boolean; name: string): TFTensor;
begin
    Result := ops.regex_replace(input, pattern, rewrite, replace_global, name);
end;

function StringsApi.substr(input: TFTensor; pos, len: Integer; name, uint: string): TFTensor;
begin
    Result := ops.substr(input, pos, len, uint, name);
end;

function StringsApi.substr(input: String; pos, len: Integer; name, uint: string): TFTensor;
begin
    Result := ops.substr(input, pos, len, uint, name);
end;
{$ENDREGION}

{$REGION 'GraphKeys'}
{ GraphKeys }

class function TGraphKeys.Create: TGraphKeys;
begin
    CONCATENATED_VARIABLES       := CONCATENATED_VARIABLES_;
    TRAINABLE_VARIABLES          := TRAINABLE_VARIABLES_;
    TRAINABLE_RESOURCE_VARIABLES := TRAINABLE_RESOURCE_VARIABLES_;
    _STREAMING_MODEL_PORTS       := _STREAMING_MODEL_PORTS_;
    LOCAL_VARIABLES              := LOCAL_VARIABLES_;
    LOSSES                       := LOSSES_;
    METRIC_VARIABLES             := METRIC_VARIABLES_;
    MOVING_AVERAGE_VARIABLES     := MOVING_AVERAGE_VARIABLES_;
    GLOBAL_VARIABLES             := GLOBAL_VARIABLES_;
    TRAIN_OP                     := TRAIN_OP_;
    GLOBAL_STEP                  := GLOBAL_STEP_;
    GLOBAL_STEP_READ_KEY         := 'global_step_read_op_cache';
    _VARIABLE_COLLECTIONS := TArray.Copy<string>(_VARIABLE_COLLECTIONS_);
    SAVEABLE_OBJECTS             := SAVEABLE_OBJECTS_;
    UPDATE_OPS                   := UPDATE_OPS_;
    SUMMARIES                    := SUMMARIES_;
    _SUMMARY_COLLECTION          := _SUMMARY_COLLECTION_;
    COND_CONTEXT                 := COND_CONTEXT_;
    WHILE_CONTEXT                := WHILE_CONTEXT_;
end;
{$ENDREGION}


initialization
begin
    tf := TTensorflow.Create;
end;

finalization
begin
     tf.Free;
end;

end.




