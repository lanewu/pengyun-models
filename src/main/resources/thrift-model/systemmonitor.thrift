/**
 * This thrift defines a service interface for testing performance 
 */

namespace java py.thrift.systemmonitor.service

struct TTimeSpan {
    1: i64 startTime,
    2: i64 stopTime
}

enum TResourceType {
    NONE,
    VOLUME,
    STORAGE_POOL,
    STORAGE,
    GROUP,
    MACHINE,
    JVM,
    NETWORK,
    DISK
}

struct TResourceIdentifier {
    1: TResourceType resourceType,
    2: i64 metadataIndex
}

struct TField {
    1:  i64 id,
    2:  string name,
    3:  string type,
    4:  binary data,
    5:  i64 timeStamp,
    6:  TResourceType resourceType,
    7:  string resourceId
}

struct TPerformanceItem {
    2: i64 itemId,    
    3: TResourceType resourceType,
    4: string itemName,
    5: string range,
    6: string unitOfMeasurement
}

enum TaskStatus_Thrift {
   NEW,
   STARTING,
   RUNNING,
   PAUSED,
   STOPPED,
   FAILED,
   TERMINATED
}

struct TPerformanceTask {
    1: i64 taskId,
    2: string taskName,
    3: i64 period,
    4: list<TTimeSpan> runTime,
    5: map<TResourceIdentifier, set<string>> resourceRelatedAttributes,
    6: string taskDescription,
    7: TaskStatus_Thrift taskStatus
}

enum TAlarmLevel{
    CRITICAL,
    MAJOR,
    MINOR,
    WARNING
}

struct TFinalAlarm {
    1: string id,
    2: string templateId,
    3: string alarmObject,
    4: string name,
    5: TAlarmLevel level,
    6: string description,
    7: i64 timestamp
}

struct TAttributeDimension {
    1: i64 attributeMetadataId,
    2: string expression,
    3: i64 times
}

struct TAlarmRule {
    1: set<TAttributeDimension> times,
    2: i64 timeWindow,
    3: i64 duration,
    4: string expression
}

struct TAlarmTemplate {
    1: string id,
    2: string name,
    3: TAlarmLevel level,
    4: list<string> subscribers,
    5: TAlarmRule rule,
    6: string description,
    7: string advice
}

/**
 * ----------------------------------------------------requests&responses----------------------------------------------------
 */
struct CreatePerformanceTaskRequest {
    1: i64 requestId,
    2: TPerformanceTask task
}

struct CreatePerformanceTaskResponse {
    1: i64 responseId
}

struct StartPerformanceTaskRequest {
    1: i64 requestId,
    2: i64 taskId
}

struct StartPerformanceTaskResponse {
    1: i64 responseId
}

struct StopPerformanceTaskRequest {
    1: i64 requestId,
    2: i64 taskId
}

struct StopPerformanceTaskResponse {
    1: i64 responseId
}

struct GetHistoryOfPerformanceRequest {
    1: i64 requestId,
    2: list<TTimeSpan> queryTimeSpan,
    3: map<string,set<TResourceIdentifier>> performanceItems
}

struct GetHistoryOfPerformanceResponse {
    1: i64 responseId,
    2: list<TField> data
}

struct AckAlarmRequest {
    1: i64 requestId,
    2: set<string> alarmIDs
}

struct AckAlarmResponse {
    1: i64 responseId,
}

struct ClearAlarmRequest {
    1: i64 requestId,
    2: set<string> alarmIDs 
}

struct ClearAlarmResponse {
    1: i64 responseId
}

struct GetHistoryAlarmRequest {
    1: i64 requestId,
    2: TTimeSpan queryTimeSpan,
    3: set<string> alarmTemplateIDs
}

struct GetHistoryAlarmResponse {
    1: i64 responseId,
    2: set<TFinalAlarm> alarms
}

struct ListAllPerformanceItemsRequest {
    1: i64 requestId,
    2: i64 offset,
    3: i64 itemCount
}

struct ListAllPerformanceItemsResponse {
    1: i64 responseId,
    2: i64 itemRemain,
    3: list<TPerformanceItem> items
}

struct ListAllPerformanceTaskRequest {
    1: i64 requestId
}

struct ListAllPerformanceTaskResponse {
    1: i64 responseId,
    2: list<TPerformanceTask> tasks
}

struct RemovePerformanceTaskRequest {
    1: i64 requestId,
    2: i64 taskId
}

struct RemovePerformanceTaskResponse {
    1: i64 responseId
}

struct CreateAlarmTemplateRequest {
    1: i64 requestId,
    2: list<TAlarmTemplate> alarmTempaltes
}

struct CreateAlarmTemplateResponse {
    1: i64 responseId
}

struct ListAlarmTemplateRequest {
    1: i64 requestId
}

struct ListAlarmTemplateResponse {
    1: i64 responseId,
    2: set<TAlarmTemplate> alarmTemplates
}

struct RemoveAlarmTemplateRequest {
    1: i64 requestId,
    2: string alarmTemplateID 
}

struct RemoveAlarmTemplateResponse {
    1: i64 responseId
}

struct UpdateAlarmTemplateRequest {
    1: i64 requestId,
    2: TAlarmTemplate alarmTemplate
}

struct UpdateAlarmTemplateResponse {
    1: i64 responseId
}


/**
 * Email configuration
 */
struct TEmailProperties {
    1: string name,
    2: string senderAddress,
    3: string senderPassword,
    4: set<string> destAddresses,
}

struct TOptionalSmtpServer {
    1: string name,
    2: string senderServerHost,
    3: string postfix,
    4: i16 senderServerPort,
    5: bool validate,
    6: bool ssl
}

struct SetEmailPropertiesRequest {
    1: i64 requestId,
    2: TEmailProperties emailProperties
}

struct SetEmailPropertiesResponse {
    1: i64 responseId
}

struct GetEmailPropertiesRequest {
    1: i64 requestId
}

struct GetEmailPropertiesResponse {
    1: i64 responseId,
    2: TEmailProperties emailProperties
}

struct AddOptionalSmtpServerRequest {
    1: i64 requestId,
    2: TOptionalSmtpServer optionalSmtpServer
}

struct AddOptionalSmtpServerResponse {
    1: i64 responseId
}

struct UpdateOptionalSmtpServerRequest {
    1: i64 requestId,
    2: TOptionalSmtpServer optionalSmtpServer
}

struct UpdateOptionalSmtpServerResponse {
    1: i64 responseId
}

struct DeleteOptionalSmtpServerRequest {
    1: i64 requestId,
    2: string optionalSmtpServerName
}

struct DeleteOptionalSmtpServerResponse {
    1: i64 responseId
}

struct ListOptionalSmtpServerRequest {
    1: i64 requestId,
}

struct ListOptionalSmtpServerResponse {
    1: i64 responseId,
    2: set<TOptionalSmtpServer> optionalSmtpServer
}


/**
 * ----------------------------------------------------exceptions----------------------------------------------------
 */
exception InvailidInputException {
  1: optional string detail
}

exception PerformanceCreationException {
  1: optional string detail
}

exception PerformanceTaskExistedException {
  1: optional string detail
}

exception PerformanceTaskStartingException {
  1: optional string detail
}

exception PerFormanceTaskStopException {
  1: optional string detail
}

exception AlarmTaskStartingException {
  1: optional string detail
}

exception AlarmTaskCreationException {
  1: optional string detail
}

exception ClearAlarmException {
  1: optional string detail
}

exception AlarmTaskStoppingException {
  1: optional string detail
}

exception AlarmStoreException {
  1: optional string detail
}

exception TEmptyStoreException {
  1: optional string detail
}

exception InternalException {
  1: optional string detail
}

exception PerformanceStoreException {
  1: optional string detail
}

exception NoTaskExistedException {
  1: optional string detail
}

exception NoAlarmTemplateExistedException {
  1: optional string detail
}

exception TAlreadyExistedException {
  1: optional string detail
}

exception TNotExistedException {
  1: optional string detail
}

/**
 * ----------------------------------------------------service----------------------------------------------------
 */
service MonitorCenter {
    // Healthy?
    void ping(),

    //Shutdown 
    void shutdown(),

    ListAllPerformanceTaskResponse listAllPerformanceTask(1: ListAllPerformanceTaskRequest request) throws (
        1: NoTaskExistedException ntee,
        2: InternalException ie
        ),

    ListAllPerformanceItemsResponse listAllPerformanceItems(1: ListAllPerformanceItemsRequest request) throws (
        1: InternalException ie
        ),

    RemovePerformanceTaskResponse removePerformanceTask(1: RemovePerformanceTaskRequest request) throws (
        1: InternalException ie
        ),

    CreatePerformanceTaskResponse createPerformanceTask(1: CreatePerformanceTaskRequest request) throws (
        1: InvailidInputException iie,
        2: PerformanceCreationException pce,
        3: PerformanceTaskExistedException ptee,
        4: InternalException ie
        ),

    StartPerformanceTaskResponse startPerformanceTask(1: StartPerformanceTaskRequest request) throws (
        1: PerformanceTaskStartingException pstrte,
        2: InternalException ie
        ),

    StopPerformanceTaskResponse stopPerformanceTask(1: StopPerformanceTaskRequest request) throws (
        1: PerFormanceTaskStopException pstpe,
        2: InternalException ie
        ),

    GetHistoryOfPerformanceResponse getHistoryOfPerformance(1: GetHistoryOfPerformanceRequest request) throws (
        1: PerformanceStoreException pstre,
        2: InternalException ie
        ),

    AckAlarmResponse ackAlarm(1: AckAlarmRequest request) throws ( 
        1: InvailidInputException iie,
        2: InternalException ie
        ),

    ClearAlarmResponse clearAlarm(1: ClearAlarmRequest request) throws (
        1: InvailidInputException iie,
        2: ClearAlarmException cae,
        3: InternalException ie
        ),

    GetHistoryAlarmResponse getHistoryAlarm(1: GetHistoryAlarmRequest request) throws (
        1: AlarmStoreException ase,
        2: TEmptyStoreException ese,
        3: InvailidInputException iie,
        4: InternalException ie
        ),
 
    CreateAlarmTemplateResponse createAlarmTemplate(1: CreateAlarmTemplateRequest request) throws (
        1: InvailidInputException iie,
        2: TAlreadyExistedException aee,
        3: InternalException ie
        ),

    ListAlarmTemplateResponse listAlarmTemplate(1: ListAlarmTemplateRequest request) throws (
        1: NoAlarmTemplateExistedException natee,
        2: InvailidInputException iie,
        3: InternalException ie
        ),

    UpdateAlarmTemplateResponse updateAlarmTemplate(1: UpdateAlarmTemplateRequest request) throws (
        1: TNotExistedException nee,
        2: InvailidInputException iie,
        3: InternalException ie
        ),

    RemoveAlarmTemplateResponse removeAlarmTemplate(1: RemoveAlarmTemplateRequest request) throws (
        1: TNotExistedException nee,
        2:InternalException ie
        ),

    SetEmailPropertiesResponse setEmailProperties(1: SetEmailPropertiesRequest request) throws (
        1: InternalException ie
        ),

    GetEmailPropertiesResponse getEmailProperties(1: GetEmailPropertiesRequest request) throws (
        1: InternalException ie
        ),

    AddOptionalSmtpServerResponse addOptionalSmtpServer(1: AddOptionalSmtpServerRequest request) throws (
        1: TAlreadyExistedException aee,
        2: InternalException ie
        ),

    UpdateOptionalSmtpServerResponse updateOptionalSmtpServer(1: UpdateOptionalSmtpServerRequest request) throws (
        1: TNotExistedException nee,
        2: InternalException ie
        ),

    DeleteOptionalSmtpServerResponse deleteOptionalSmtpServer(1: DeleteOptionalSmtpServerRequest request) throws (
        1: TNotExistedException nee,
        2: InternalException ie
        ),

    ListOptionalSmtpServerResponse listOptionalSmtpServer(1: ListOptionalSmtpServerRequest request) throws (
        1: TEmptyStoreException tese,
        2: InternalException ie
        ),
}
