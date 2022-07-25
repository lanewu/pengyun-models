include "shared.thrift"
include "icshared.thrift"
/**
 * This thrift defines a service interface for processor server
 */

namespace java py.thrift.monitorserver.service

/**
 * ----------------------------------------------------requests&responses----------------------------------------------------
 */

struct MetricsCollectionResolveRequest {
    1:i64 requestId,
    2:i32 querylogAmount,
    3:i64 querylogLength,
    4:bool isCompressed,
    5:string querylogString
}


struct AlertMessage_Thrift {
    1: string id,
    2: string sourceId,
    3: string sourceName,
    4: string alertDescription,
    5: string alertLevel,
    6: string alertType,
    7: string alertRuleName,
    8: bool alertAcknowledge,
    9: i64 alertAcknowledgeTime,
    10: i64 firstAlertTime,
    11: i64 lastAlertTime,
    12: i32 alertFrequency
}

struct EventLogInfo_Thrift {
    1: i64 id,
    2: i64 startTime,
    3: string eventLog
}

struct AlertMessageDetail_Thrift {
    1: AlertMessage_Thrift alertMessageThrift,
    2: optional string ip,
    3: optional string hostname,
    4: optional string alertItem,
    5: optional string serialNum,
    6: optional string slotNo,
    7: optional string serverNodeRackNo,
    8: optional string serverNodeChildFramNo,
    9: optional string serverNodeSlotNo,
    10: optional string lastActualValue,
    11: optional set<EventLogInfo_Thrift> eventLogInfoSet
}


//**************** alert message readfiletosendprocessor begin ******************************/
struct MetricsCollectionResolveResponse {
   1:i64 requestId,
}

struct AlertsAcknowledgeRequest_Thrift {
    1: i64 requestId,
    2: list<string> alertMessageIds
}

struct AlertsAcknowledgeResponse_Thrift {
    1: i64 responseId
}

struct ClearAlertsAcknowledgeRequest_Thrift {
    1: i64 requestId,
    2: list<string> alertMessageIds
}

struct ClearAlertsAcknowledgeResponse_Thrift {
    1: i64 responseId
}

struct AlertsClearRequest_Thrift {
    1: i64 requestId,
    2: list<string> alertMessageIds
}

struct AlertsClearResponse_Thrift {
    1: i64 responseId
}

struct DeleteAlertRequest_Thrift {
    1: i64 requestId,
    2: string alertMessageId
}

struct DeleteAlertResponse_Thrift {
    1: i64 responseId
}

struct DeleteAlertsRequest_Thrift {
    1: i64 requestId,
    2: list<string> alertMessageIds
}

struct DeleteAlertsResponse_Thrift {
    1: i64 responseId
}

struct GetAlertMessageDetailRequest_Thrift {
    1: i64 requestId,
    2: i64 alertMessageId,
    3: optional bool withEventLog
}

struct GetAlertMessageDetailResponse_Thrift {
    1: i64 responseId,
    2: AlertMessageDetail_Thrift alertMessageDetail
}

struct ListAlertsByTableRequest_Thrift {
    1: i64 requestId,
    2: optional i32 pageSize,
    3: optional i32 pageNo,
    4: optional string sortFeild,
    5: optional string sortDirection,
    6: optional string sourceId,
    7: optional string sourceName,
    8: optional i64 startTime,
    9: optional i64 endTime,
    10: optional string alertLevel,
    11: optional bool acknowledge,
    12: optional string alertType,
    13: optional string alertRuleName,
}

struct ListAlertByTableResponse_Thrift {
    1: i64 responseId,
    2: i32 recordsTotal,
    3: i32 recordsAfterFilter,
    4: list<AlertMessage_Thrift> alertMessageList,
}

struct ListAlertCountRequest_Thrift {
    1: i64 requestId,
    2: optional bool acknowledge,
    3: optional string alertLevel,
    4: optional string alertType,
    5: optional i64 startTime,
    6: optional i64 endTime,
    7: optional string alertRuleName
}

struct ListAlertCountResponse_Thrift {
    1: i64 responseId,
    2: i32 recordsTotal,
}

struct TotalRecords {
    1: i32 criticalAlertCount,
    2: i32 majorAlertCount,
    3: i32 minorAlertCount,
    4: i32 warningAlertCount,
    5: i32 clearedAlertCount;
}

struct ListAllAlertCountRequest_Thrift {
    1: i64 requestId,
    2: optional bool acknowledge,
    3: optional string alertType,
    4: optional i64 startTime,
    5: optional i64 endTime,
    6: optional string alertRuleName;
}

struct ListAllAlertCountResponse_Thrift {
    1: i64 responseId,
    2: TotalRecords recordsTotal;
}

//**************** alert message readfiletosendprocessor end ******************************/



//**************** performance message task start ******************************/
struct PerformanceTask_Thrift {
    1: i64 requestId,
    2: string id,
    3: string counterKey,
    4: string sourceId,
    5: string sourceName,
    6: i64 startTime,
    7: bool status,
}

struct CreatePerformanceTaskRequest_Thrift {
    1: i64 requestId,
    2: string counterKey,
    3: optional string sourceId,
    4: optional string sourceName,
}

struct CreatePerformanceTaskReponse_Thrift {
    1: i64 reponseId,
}

struct DeletePerformanceTaskRequest_Thrift {
    1: i64 requestId,
    2: set<string> ids,
}

struct DeletePerformanceTaskResponse_Thrift {
    1: i64 responseId,
}

struct StartPerformanceTaskRequest_Thrift {
    1: i64 requestId,
    2: set<string> ids,
}

struct StartPerformanceTaskResponse_Thrift {
    1: i64 responseId,
}

struct StopPerformanceTaskRequest_Thrift {
    1: i64 requestId,
    2: set<string> ids,
}

struct StopPerformanceTaskResponse_Thrift {
    1: i64 responseId,
}

struct ListPerformanceTaskRequest_Thrift {
    1: i64 requestId,
}

struct ListPerformanceTaskReponse_Thrift {
    1: i64 responseId,
    2: set<PerformanceTask_Thrift> performanceTasks,
}

struct EventLogCompressed_Thrift {
    1: string id,
    2: string counterKey,
    3: i64 startTime,
    4: i64 endTime,
    5: i64 counterTotal,
    6: i32 frequency,
    7: string sourceId,
    8: string operation,
}

struct ListCompressedPerformanceByCountRequest_Thrift {
    1: i64 requestId,
    2: i32 count,
    3: optional string sortFeild,
    4: optional string sortDirection,
    5: optional string counterKey,
    6: optional i64 startTime,
    7: optional i64 endTime,
    8: optional string sourceId,
}

struct ListCompressedPerformanceByCountResponse_Thrift {
    1: i64 responseId,
    2: list<EventLogCompressed_Thrift> eventLogMessageThriftList,
    3: i64 timeInterval,
}

struct CompressedPerformanceDataPoint_Thrift {
    1: string counterValue,
    2: i64 startTime,
    3: i64 endTime,
}

struct SourceObject_Thrift {
    1: string sourceId,
    2: string sourceName,
}

struct CompressedPerformanceData_Thrift {
    1: SourceObject_Thrift sourceObject,
    2: string counterKey,
    3: list<CompressedPerformanceDataPoint_Thrift> compressedPerformanceDataPointList,
}

enum PerformanceDataTimeUnit{
    FIVE_MINUTES = 1,
    ONE_HOUR = 2,
    ONE_DAY = 3,
}

struct ListMultiCompressedPerformanceDataRequest_Thrift {
    1: i64 requestId,
    2: optional i32 count,
    3: optional i64 startTime,
    4: optional i64 endTime,
    5: list<SourceObject_Thrift> sourceObjects,
    6: list<string> counterKeys,
    7: optional PerformanceDataTimeUnit performanceDataTimeUnit,
}

struct ListMultiCompressedPerformanceDataResponse_Thrift {
    1: i64 responseId,
    2: i64 timeInterval,
    3: list<CompressedPerformanceData_Thrift> compressedPerformanceDataList;
}

struct GetPerformanceDataTimeSpanRequest_Thrift {
    1: i64 requestId,
}

struct GetPerformanceDataTimeSpanResponse_Thrift {
    1: i64 responseId,
    2: map<PerformanceDataTimeUnit, i32> timeSpanMap,
    3: map<PerformanceDataTimeUnit, i32> retentionTimeMap,
}

struct ListCompressedPerformanceRequest_Thrift {
    1: i64 requestId,
    2: i32 pageSize,
    3: optional i32 page,
    4: optional string sortFeild,
    5: optional string sortDirection,
    6: optional string counterKey,
    7: optional i64 startTime,
    8: optional i64 endTime,
    9: optional string sourceId,
}

struct ListCompressedPerformanceResponse_Thrift {
    1: i64 responseId,
    2: i32 recordsTotal,
    3: i32 recordsAfterFilter,
    4: list<EventLogCompressed_Thrift> eventLogMessageThriftList,
}

//**************** performance message task end ******************************/

//**************** alert template start ******************************/

struct AlertRule_Thrift {
    1: string id;
    2: string name,
    3: string counterKey,
    4: string description,
    5: string alertLevelOne,
    6: string alertLevelTwo,
    7: i32 alertLevelOneThreshold,
    8: i32 alertLevelTwoThreshold,
    9: string relationOperator,
    10: i32 continuousOccurTimes,
    11: bool repeatAlert,
    12: string leftId,
    13: string rightId,
    14: string parentId,
    15: string logicOperator,
    16: string alertTemplateId,
    17: i32 alertRecoveryThreshold,
    18: string alertRecoveryLevel,
    19: i32 alertRecoveryEventContinuousOccurTimes,
    20: string alertRecoveryRelationOperator,
    21: bool enable,
}

struct AlertTemplate_Thrift {
    1: string id,
    2: string name,
    3: string sourceId,
    4: map<string, AlertRule_Thrift> alertRuleMap, 
}

struct GetAlertTemplateRequest_Thrift {
    1: i64 requestId,
    2: optional string id,
}

struct GetAlertTemplateResponse_Thrift {
    1: i64 reponseId,
    2: map<string, AlertTemplate_Thrift> alertTemplateMap,
}

//struct DeleteAlertTemplateRequest_Thrift {
//    1: i64 requestId,
//    2: optional string id,
//}
//
//struct DeleteAlertTemplateResponse_Thrift {
//    1: i64 responseId,
//}
//
//struct UpdateAlertTemplateRequest_Thrift {
//    1: i64 requestId,
//    2: AlertTemplate_Thrift alertTemplate,
//}
//
//struct UpdateAlertTemplateResponse_Thrift {
//    1: i64 responseId,
//}
//

struct ListNotUsedCounterKeyRequest_Thrift {
    1: i64 requestId,
}

struct ListNotUsedCounterKeyResponse_Thrift {
    1: i64 requestId,
    2: map<string, list<string>> templateKey2CounterKeyMap;
}

struct CreateAlertRuleRequest_Thrift {
    1: i64 requestId,
    2: string name,
    3: string counterKey,
    4: optional string description,
    5: string alertLevelOne,
    6: optional string alertLevelTwo,
    7: optional i32 alertLevelOneThreshold,
    8: optional i32 alertLevelTwoThreshold,
    9: optional string relationOperator,
    10: optional i32 continuousOccurTimes,
    11: optional bool repeatAlert,
    12: optional string leftId,
    13: optional string rightId,
    14: optional string parentId,
    15: optional string logicOperator,
    16: optional string alertTemplateId,
    17: optional i32 alertRecoveryThreshold,
    18: optional string alertRecoveryLevel,
    19: optional i32 alertRecoveryEventContinuousOccurTimes,
    20: optional string alertRecoveryRelationOperator,
}

struct CreateAlertRuleResponse_Thrift {
    1: i64 responseId,
}

struct DeleteAlertRuleRequest_Thrift {
    1: i64 requestId,
    2: string alertRuleId,
}

struct DeleteAlertRuleResponse_Thrift {
    1: i64 responseId,
}

struct MergeAlerRuleRequest_Thrift {
    1: i64 requestId,
    2: string name,
    3: string leftId,
    4: string rightId,
    5: string logicOperator,
    6: optional string description,
    7: string alertLevelOne,
    8: optional string alertLevelTwo,
    9: bool repeatAlert,
    10: string recoveryAlertLevel,
    11: string recoveryAlertOperator,
}

struct MergeAlerRuleResponse_Thrift {
    1: i64 responseId,
}

struct UpdateAlertRuleRequest_Thrift {
    1: i64 requestId,
    2: string id,
    3: optional string name,
    4: optional string description,
    5: optional string alertLevelOne,
    6: optional i32 alertLevelOneThreshold,
    7: optional string alertLevelTwo,
    8: optional i32 alertLevelTwoThreshold,
    9: optional string relationOperator,
    10: optional string logicOperator,
    11: optional i32 continuousOccurTimes,
    12: optional bool repeatAlert,
    13: optional i32 alertRecoveryThreshold,
    14: optional string alertRecoveryLevel,
    15: optional i32 alertRecoveryEventContinuousOccurTimes,
    16: optional string alertRecoveryRelationOperator,
    17: optional bool enable,
}

struct UpdateAlertRuleReponse_Thrift {
    1: i64 responseId,
}

struct EnableAlertRuleRequest_Thrift {
    1: i64 requestId,
    2: set<i64> ids,
}

struct EnableAlertRuleResponse_Thrift {
    1: i64 responseId,
}

struct DisableAlertRuleRequest_Thrift {
    1: i64 requestId,
    2: set<i64> ids,
}

struct DisableAlertRuleResponse_Thrift {
    1: i64 responseId,
}

//struct AddBaseAlertTemplateRequest_Thrift {
//    1: i64 requestId,
//    2: BaseAlertTemplate_Thrift baseAlertTemplateThrift,
//}
//
//struct AddBaseAlertTemplateResponse_Thrift {
//    1: i64 responseId,
//}
//
//struct DeleteBaseAlertTemplateRequest_Thrift {
//    1: i64 requestId,
//    2: string baseAlertTemplateKey,
//}
//
//struct DeleteBaseAlertTemplateResponse_Thrift {
//    1: i64 responseId,
//}


//**************** alert template end ******************************/


//**************** snmp forward setting start ******************************/

enum SnmpVersion {
    SNMPV1 = 1,
    SNMPV2C = 2,
    SNMPV3 = 3,
}

enum SecurityLevel {
    NoAuthNoPriv =1,
    AuthNoPriv =2,
    AuthPriv = 3,
}

enum AuthProtocol {
    MD5 = 1,
    SHA = 2,
}

enum PrivProtocol {
    AES = 1,
    DES = 2,
}

enum Language {
    ENGLISH = 1,
    CHINESE = 2,
}

enum LanguageFormat {
    UTF_8 = 1,
    GB2312 = 2,
}

struct SaveSnmpForwardItemResponse_Thrift {
    1: i64 responseId,
}

struct SaveSnmpForwardItemRequest_Thrift {
    1: i64 requestId,
    2: string trapServerip,
    3: i32 trapServerport,
    4: bool enable,
    5: SnmpVersion snmpVersion,
    6: string community,
    7: SecurityLevel securityLevel,
    8: string securityName,
    9: AuthProtocol authProtocol,
    10: PrivProtocol privProtocol,
    11: string authKey,
    12: string privKey,
    13: string NMSName,
    14: string NMSDescription,
    15: i32 timeoutMS,
    16: optional Language language,
    17: optional LanguageFormat languageFormat,
}

struct UpdateSnmpForwardItemRequest_Thrift {
    1: i64 requestId,
    2: i64 id,
    3: string trapServerip,
    4: i32 trapServerport,
    5: bool enable,
    6: SnmpVersion snmpVersion,
    7: string community,
    8: SecurityLevel securityLevel,
    9: string securityName,
    10: AuthProtocol authProtocol,
    11: PrivProtocol privProtocol,
    12: string authKey,
    13: string privKey,
    14: string NMSName,
    15: string NMSDescription,
    16: i32 timeoutMS,
    17: optional Language language,
    18: optional LanguageFormat languageFormat,
}

struct UpdateSnmpForwardItemResponse_Thrift {
    1: i64 responseId,
}

struct SnmpForwardItem_Thrift {
    1: i64 id,
    2: string trapServerip,
    3: i32 trapServerport,
    4: bool enable,
    5: SnmpVersion snmpVersion,
    6: string community,
    7: SecurityLevel securityLevel,
    8: string securityName,
    9: AuthProtocol authProtocol,
    10: PrivProtocol privProtocol,
    11: string authKey,
    12: string privKey,
    13: string NMSName,
    14: string NMSDescription,
    15: i32 timeoutMS,
    16: Language language,
    17: LanguageFormat languageFormat,
}

struct DeleteSnmpForwardItemRequest_Thrift {
    1: i64 requestId,
    2: list<i64> snmpForwardItemIdList,
}

struct DeleteSnmpForwardItemResponse_Thrift {
    1: i64 responseId,
}

struct ListSnmpForwardItemRequest_Thrift {
    1: i64 requestId,
}
struct ListSnmpForwardItemResponse_Thrift {
    1: i64 responseId,
    2: list<SnmpForwardItem_Thrift> snmpForwardItemThriftList,
}

//**************** snmp forward setting end ******************************/

//**************** email forward setting start ******************************/

struct SaveEmailForwardItemResponse_Thrift {
    1: i64 responseId,
}

struct SaveEmailForwardItemRequest_Thrift {
    1: i64 requestId,
    2: string email,
    3: optional string name,
    4: optional string desc
    5: bool enable,
}

struct UpdateEmailForwardItemRequest_Thrift {
    1: i64 requestId,
    2: i64 id,
    3: string email,
    4: string name,
    5: string desc
    6: bool enable,
}

struct UpdateEmailForwardItemResponse_Thrift {
    1: i64 responseId,
}

struct EmailForwardItem_Thrift {
    1: i64 id,
    2: optional string email,
    3: optional string name,
    4: optional string desc,
    5: optional bool enable,
}

struct DeleteEmailForwardItemRequest_Thrift {
    1: i64 requestId,
    2: list<EmailForwardItem_Thrift> emailForwardItemThriftList,
}

struct DeleteEmailForwardItemResponse_Thrift {
    1: i64 responseId,
}

struct ListEmailForwardItemRequest_Thrift {
    1: i64 requestId,
}
struct ListEmailForwardItemResponse_Thrift {
    1: i64 responseId,
    2: list<EmailForwardItem_Thrift> emailForwardItemThriftList,
}

//**************** email forward setting end ******************************/


//**************** Message forward setting start ******************************/

struct SaveMessageForwardItemResponse_Thrift {
    1: i64 responseId,
}

struct SaveMessageForwardItemRequest_Thrift {
    1: i64 requestId,
    2: string phoneNum,
    3: optional string name,
    4: optional string desc
    5: bool enable,
}

struct UpdateMessageForwardItemRequest_Thrift {
    1: i64 requestId,
    2: i64 id,
    3: string phoneNum,
    4: string name,
    5: string desc
    6: bool enable,
}

struct UpdateMessageForwardItemResponse_Thrift {
    1: i64 responseId,
}

struct MessageForwardItem_Thrift {
    1: i64 id,
    2: optional string phoneNum,
    3: optional string name,
    4: optional string desc,
    5: optional bool enable,
}

struct DeleteMessageForwardItemRequest_Thrift {
    1: i64 requestId,
    2: list<MessageForwardItem_Thrift> messageForwardItemThriftList,
}

struct DeleteMessageForwardItemResponse_Thrift {
    1: i64 responseId,
}

struct ListMessageForwardItemRequest_Thrift {
    1: i64 requestId,
}

struct ListMessageForwardItemResponse_Thrift {
    1: i64 responseId,
    2: list<MessageForwardItem_Thrift> messageForwardItemThriftList,
}

struct GetMessageForwardItemRequest_Thrift {
    1: i64 requestId,
    2: list<string> phoneNumList,
}

struct GetMessageForwardItemResponse_Thrift {
    1: i64 responseId,
    2: list<MessageForwardItem_Thrift> messageForwardItemThriftList,
}

//**************** Message fowward setting end ******************************/

//**************** SMTP setting end ******************************/

enum SmtpContentType_Thrift {
    PLAIN = 1,
    HTML = 2,
}

enum SmtpEncryptType_Thrift {
    AUTH = 1,
    SSL = 2 ,
    TLS = 3,
}

struct SmtpItem_Thrift {
    1: bool enable,
    2: string userName;
    3: string password;
    4: i32 smtpPort;
    5: SmtpEncryptType_Thrift encryptType;
    6: string subject;
    7: string smtpServer;
    8: SmtpContentType_Thrift contentType;
}

struct SaveOrUpdateSmtpItemRequest_Thrift {
    1: i64 requestId,
    2: SmtpItem_Thrift smtpItme_Thrift,
}

struct SaveOrUpdateSmtpItemResponse_Thrift {
    1: i64 responseId,
}

struct GetSmtpItemRequest_Thrift {
    1: i64 requestId,
}

struct GetSmtpItemResponse_Thrift {
    1: i64 responseId,
    2: SmtpItem_Thrift smtpItme_Thrift,
}

//**************** SMTP setting end ******************************/

//**************** SMTP Send Email begin ******************************/

struct CheckSmtpSendEmailRequest_Thrift {
    1: i64 requestId,
    2: string smtpHost,
    3: string userName,
    4: string password,
    5: i32 smtpPort,
    6: SmtpEncryptType_Thrift encryptType,
    7: SmtpContentType_Thrift contentType,
    8: string subject,
}

struct CheckSmtpSendEmailResponse_Thrift {
    1: i64 responseId,
}

//**************** SMTP Send Email end ******************************/


//********************************* MonitorServer user authentification begin **********************************************************/
/*
StartPerformanceTask
StopPerformanceTask
CreatePerformanceTask
DeletePerformanceTask
ListPerformanceTask
 */
struct StartPerformanceTaskRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: StartPerformanceTaskRequest_Thrift request,
}
struct StartPerformanceTaskResponse {
    1: i64 responseId,
    2: StartPerformanceTaskResponse_Thrift response,
}

struct StopPerformanceTaskRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: StopPerformanceTaskRequest_Thrift request,
}
struct StopPerformanceTaskResponse {
    1: i64 responseId,
    2: StopPerformanceTaskResponse_Thrift response,
}

struct CreatePerformanceTaskRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: CreatePerformanceTaskRequest_Thrift request,
}
struct CreatePerformanceTaskResponse {
    1: i64 responseId,
    2: CreatePerformanceTaskReponse_Thrift response,
}

struct DeletePerformanceTaskRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: DeletePerformanceTaskRequest_Thrift request,
}
struct DeletePerformanceTaskResponse {
    1: i64 responseId,
    2: DeletePerformanceTaskResponse_Thrift response,
}

struct ListPerformanceTaskRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: ListPerformanceTaskRequest_Thrift request,
}
struct ListPerformanceTaskResponse {
    1: i64 responseId,
    2: ListPerformanceTaskReponse_Thrift response,
}

/*
ListCompressedPerformanceByCount
ListMultiCompressedPerformanceData
 */
struct ListCompressedPerformanceByCountRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: ListCompressedPerformanceByCountRequest_Thrift request,
}
struct ListCompressedPerformanceByCountResponse {
    1: i64 responseId,
    2: ListCompressedPerformanceByCountResponse_Thrift response,
}
struct ListMultiCompressedPerformanceDataRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: ListMultiCompressedPerformanceDataRequest_Thrift request,
}
struct ListMultiCompressedPerformanceDataResponse {
    1: i64 responseId,
    2: ListMultiCompressedPerformanceDataResponse_Thrift response,
}

/*
GetAlertTemplate
CreateAlertRule
DeleteAlertRule
MergeAlertRule
UpdateAlertRule
*/
struct GetAlertTemplateRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: GetAlertTemplateRequest_Thrift request,
}
struct GetAlertTemplateResponse {
    1: i64 responseId,
    2: GetAlertTemplateResponse_Thrift response,
}
struct CreateAlertRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: CreateAlertRuleRequest_Thrift request,
}
struct CreateAlertRuleResponse {
    1: i64 responseId,
    2: CreateAlertRuleResponse_Thrift response,
}
struct DeleteAlertRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: DeleteAlertRuleRequest_Thrift request,
}
struct DeleteAlertRuleResponse {
    1: i64 responseId,
    2: DeleteAlertRuleResponse_Thrift response,
}
struct MergeAlertRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: MergeAlerRuleRequest_Thrift request,
}
struct MergeAlertRuleResponse {
    1: i64 responseId,
    2: MergeAlerRuleResponse_Thrift response,
}
struct UpdateAlertRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: UpdateAlertRuleRequest_Thrift request,
}
struct UpdateAlertRuleResponse {
    1: i64 responseId,
    2: UpdateAlertRuleReponse_Thrift response,
}
struct EnableAlertRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: EnableAlertRuleRequest_Thrift request,
}
struct EnableAlertRuleResponse {
    1: i64 responseId,
    2: EnableAlertRuleResponse_Thrift response,
}
struct DisableAlertRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: DisableAlertRuleRequest_Thrift request,
}
struct DisableAlertRuleResponse {
    1: i64 responseId,
    2: DisableAlertRuleResponse_Thrift response,
}
/*
AlertsAcknowledge
ClearAlertsAcknowledge
AlertsClear
DeleteAlert
DeleteAlerts
GetAlertMessageDetail
ListAlertsByTable
ListAlertCount
*/
struct AlertsAcknowledgeRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: AlertsAcknowledgeRequest_Thrift request,
}
struct AlertsAcknowledgeResponse {
    1: i64 responseId,
    2: AlertsAcknowledgeResponse_Thrift response,
}
struct ClearAlertsAcknowledgeRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: ClearAlertsAcknowledgeRequest_Thrift request,
}
struct ClearAlertsAcknowledgeResponse {
    1: i64 responseId,
    2: ClearAlertsAcknowledgeResponse_Thrift response,
}
struct AlertsClearRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: AlertsClearRequest_Thrift request,
}
struct AlertsClearResponse {
    1: i64 responseId,
    2: AlertsClearResponse_Thrift response,
}
struct DeleteAlertRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: DeleteAlertRequest_Thrift request,
}
struct DeleteAlertResponse {
    1: i64 responseId,
    2: DeleteAlertResponse_Thrift response,
}
struct DeleteAlertsRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: DeleteAlertsRequest_Thrift request,
}
struct DeleteAlertsResponse {
    1: i64 responseId,
    2: DeleteAlertsResponse_Thrift response,
}
struct GetAlertMessageDetailRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: GetAlertMessageDetailRequest_Thrift request,
}
struct GetAlertMessageDetailResponse {
    1: i64 responseId,
    2: GetAlertMessageDetailResponse_Thrift response,
}
struct ListAlertsByTableRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: ListAlertsByTableRequest_Thrift request,
}
struct ListAlertsByTableResponse {
    1: i64 responseId,
    2: ListAlertByTableResponse_Thrift response,
}
struct ListAlertCountRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: ListAlertCountRequest_Thrift request,
}
struct ListAlertCountResponse {
    1: i64 responseId,
    2: ListAlertCountResponse_Thrift response,
}

/*
SaveSnmpForwardItem
UpdateSnmpForwardItem
DeleteSnmpForwardItem
ListSnmpForwardItem
*/
struct SaveSnmpForwardItemRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: SaveSnmpForwardItemRequest_Thrift request,
}
struct SaveSnmpForwardItemResponse {
    1: i64 responseId,
    2: SaveSnmpForwardItemResponse_Thrift response,
}
struct UpdateSnmpForwardItemRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: UpdateSnmpForwardItemRequest_Thrift request,
}
struct UpdateSnmpForwardItemResponse {
    1: i64 responseId,
    2: UpdateSnmpForwardItemResponse_Thrift response,
}
struct DeleteSnmpForwardItemRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: DeleteSnmpForwardItemRequest_Thrift request,
}
struct DeleteSnmpForwardItemResponse {
    1: i64 responseId,
    2: DeleteSnmpForwardItemResponse_Thrift response,
}
struct ListSnmpForwardItemRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: ListSnmpForwardItemRequest_Thrift request,
}
struct ListSnmpForwardItemResponse {
    1: i64 responseId,
    2: ListSnmpForwardItemResponse_Thrift response,
}
/*
SaveEmailForwardItem
UpdateEmailForwardItem
DeleteEmailForwardItem
ListEmailForwardItem
*/
struct SaveEmailForwardItemRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: SaveEmailForwardItemRequest_Thrift request,
}
struct SaveEmailForwardItemResponse {
    1: i64 responseId,
    2: SaveEmailForwardItemResponse_Thrift response,
}
struct UpdateEmailForwardItemRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: UpdateEmailForwardItemRequest_Thrift request,
}
struct UpdateEmailForwardItemResponse {
    1: i64 responseId,
    2: UpdateEmailForwardItemResponse_Thrift response,
}
struct DeleteEmailForwardItemRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: DeleteEmailForwardItemRequest_Thrift request,
}
struct DeleteEmailForwardItemResponse {
    1: i64 responseId,
    2: DeleteEmailForwardItemResponse_Thrift response,
}
struct ListEmailForwardItemRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: ListEmailForwardItemRequest_Thrift request,
}
struct ListEmailForwardItemResponse {
    1: i64 responseId,
    2: ListEmailForwardItemResponse_Thrift response,
}
/*
SaveOrUpdateSmtpItem
GetSmtpItem
CheckSmtpSendEmail
*/
struct SaveOrUpdateSmtpItemRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: SaveOrUpdateSmtpItemRequest_Thrift request,
}
struct SaveOrUpdateSmtpItemResponse {
    1: i64 responseId,
    2: SaveOrUpdateSmtpItemResponse_Thrift response,
}
struct GetSmtpItemRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: GetSmtpItemRequest_Thrift request,
}
struct GetSmtpItemResponse {
    1: i64 responseId,
    2: GetSmtpItemResponse_Thrift response,
}
struct CheckSmtpSendEmailRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: CheckSmtpSendEmailRequest_Thrift request,
}
struct CheckSmtpSendEmailResponse {
    1: i64 responseId,
    2: CheckSmtpSendEmailResponse_Thrift response,
}

enum StatementStatisticsTimeUnit {
    day = 1,
    week = 2,
    month = 3,
    year = 4;
}
struct GetStatisticsRequest_Thrift {
    1: i64 requestId,
    2: i64 accountId,
    3: list<string> counterKeyList,
    4: StatementStatisticsTimeUnit timeUnit,
    5: i64 time,
    6: list<SourceObject_Thrift> resource;
}
struct GetStatisticsResponse_Thrift {
    1: i64 responseId,
    2: binary csvFile,
}

struct ReportMaintenanceModeInfoRequest {
    1: i64 requestId,
    2: string maintenanceIp,
    3: i64 maintenanceTime,
}
struct ReportMaintenanceModeInfoResponse {
    1: i64 responseId,
}



//********************************** MonitorServer user authentification end   **********************************************************/

 /**
 * ----------------------------------------------------exceptions----------------------------------------------------
 */
exception IllegalParameterException_Thrift {
  1: optional string detail
}


exception PerformanceTaskIsRudundantException_Thrift {
    1: optional string detail
}

exception CounterKeyExitedException_Thrift {
    1: optional string detail
}

exception CounterKeyIllegalException_Thrift {
    1: optional string detail
}

exception SmtpSendEmailException_Thrift {
    1: optional string detail
}

exception DuplicateIpPortException_Thrift {
    1: optional string detail
}

exception USMPassphrasesLengthException {
    1: optional string detail
}

exception PerformanceDataTimeSpanIsBigException_Thrift {
    1: optional string detail,
    2: optional i32 maxTimeSpanDays
}
exception PerformanceDataTimeCrossBorderException_Thrift {
    1: optional string detail,
}

 /**
 * ----------------------------------------------------service----------------------------------------------------
 */
 service MonitorServer extends shared.DebugConfigurator {
   // Healthy?
   void ping(),

   //Shutdown
   void shutdown(),
    MetricsCollectionResolveResponse metricsCollectionResolve(1:MetricsCollectionResolveRequest request)
                                                                        throws (1:shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),
   
    AlertsAcknowledgeResponse_Thrift alertsAcknowledge(1:AlertsAcknowledgeRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),
    ClearAlertsAcknowledgeResponse_Thrift clearAlertsAcknowledge(1:ClearAlertsAcknowledgeRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),

    AlertsClearResponse_Thrift alertsClear(1:AlertsClearRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),
    
    DeleteAlertResponse_Thrift deleteAlert(1:DeleteAlertRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),
    DeleteAlertsResponse_Thrift deleteAlerts(1:DeleteAlertsRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),

    GetAlertMessageDetailResponse_Thrift getAlertMessageDetail(1:GetAlertMessageDetailRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),

    ListAlertByTableResponse_Thrift listAlertsByTable(1:ListAlertsByTableRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),

    ListAlertCountResponse_Thrift listAlertCount(1:ListAlertCountRequest_Thrift request) throws(
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),

    ListAllAlertCountResponse_Thrift listAllAlertCount(1:ListAllAlertCountRequest_Thrift request) throws(
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),
                                                                                
    CreatePerformanceTaskReponse_Thrift createPerformanceTask(1:CreatePerformanceTaskRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe,
                                                                                4: PerformanceTaskIsRudundantException_Thrift ptire),
    DeletePerformanceTaskResponse_Thrift deletePerformanceTask(1:DeletePerformanceTaskRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),
    StartPerformanceTaskResponse_Thrift startPerformanceTask(1:StartPerformanceTaskRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),
    StopPerformanceTaskResponse_Thrift stopPerformanceTask(1:StopPerformanceTaskRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),
    ListPerformanceTaskReponse_Thrift listPerformanceTask(1:ListPerformanceTaskRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),
    ListCompressedPerformanceResponse_Thrift listCompressedPerformance(1:ListCompressedPerformanceRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),
    ListCompressedPerformanceByCountResponse_Thrift listCompressedPerformanceByCount(1: ListCompressedPerformanceByCountRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),
    ListMultiCompressedPerformanceDataResponse_Thrift listMultiCompressedPerformanceData(1: ListMultiCompressedPerformanceDataRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe,
                                                                                4: PerformanceDataTimeSpanIsBigException_Thrift pdtsibe,
                                                                                5: PerformanceDataTimeCrossBorderException_Thrift pdtcbe),
    GetPerformanceDataTimeSpanResponse_Thrift getPerformanceDataTimeSpan(1:GetPerformanceDataTimeSpanRequest_Thrift request) throws (
                                                                                    1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                    2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                    3: IllegalParameterException_Thrift ipe),
    GetStatisticsResponse_Thrift getPerformanceStatistics(1: GetStatisticsRequest_Thrift request) throws (
                                                                                    1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                    2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                    3: IllegalParameterException_Thrift ipe),

//    AddBaseAlertTemplateResponse_Thrift addBaseAlertTemplate(1: AddBaseAlertTemplateRequest_Thrift request) throws (
//                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
//                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
//                                                                                3: IllegalParameterException_Thrift ipe),
//    DeleteAlertTemplateResponse_Thrift deleteAlertTemplate(1:DeleteAlertTemplateRequest_Thrift request) throws (
//                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
//                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
//                                                                                3: IllegalParameterException_Thrift ipe),
//    UpdateAlertTemplateResponse_Thrift updateAlertTemplate(1:UpdateAlertTemplateRequest_Thrift request) throws (
//                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
//                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
//                                                                                3: IllegalParameterException_Thrift ipe),
    GetAlertTemplateResponse_Thrift getAlertTemplate(1:GetAlertTemplateRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),

    ListNotUsedCounterKeyResponse_Thrift listNotUsedCounterKey(1:ListNotUsedCounterKeyRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina),

    CreateAlertRuleResponse_Thrift createAlertRule(1:CreateAlertRuleRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe,
                                                                                4: CounterKeyExitedException_Thrift ckee,
                                                                                5: CounterKeyIllegalException_Thrift ckie),
    DeleteAlertRuleResponse_Thrift deleteAlertRule(1:DeleteAlertRuleRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),
    MergeAlerRuleResponse_Thrift mergeAlertRule(1: MergeAlerRuleRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),
    UpdateAlertRuleReponse_Thrift updateAlertRule(1: UpdateAlertRuleRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),
    EnableAlertRuleResponse_Thrift enableAlertRule(1: EnableAlertRuleRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),
    DisableAlertRuleResponse_Thrift disableAlertRule(1: DisableAlertRuleRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),
    SaveSnmpForwardItemResponse_Thrift saveSnmpForwardItem(1: SaveSnmpForwardItemRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe,
                                                                                4: DuplicateIpPortException_Thrift dupe),
    UpdateSnmpForwardItemResponse_Thrift updateSnmpForwardItem(1: UpdateSnmpForwardItemRequest_Thrift request) throws (
                                                                                 1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                 2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                 3: IllegalParameterException_Thrift ipe,
                                                                                 4: DuplicateIpPortException_Thrift dupe,
                                                                                 5: USMPassphrasesLengthException uple),
    DeleteSnmpForwardItemResponse_Thrift deleteSnmpForwardItem(1: DeleteSnmpForwardItemRequest_Thrift request) throws (
                                                                                 1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                 2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                 3: IllegalParameterException_Thrift ipe),
    ListSnmpForwardItemResponse_Thrift listSnmpForwardItem(1: ListSnmpForwardItemRequest_Thrift request) throws (
                                                                                 1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                 2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                 3: IllegalParameterException_Thrift ipe),
    SaveEmailForwardItemResponse_Thrift saveEmailForwardItem(1: SaveEmailForwardItemRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),
    UpdateEmailForwardItemResponse_Thrift updateEmailForwardItem(1: UpdateEmailForwardItemRequest_Thrift request) throws (
                                                                                 1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                 2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                 3: IllegalParameterException_Thrift ipe),
    DeleteEmailForwardItemResponse_Thrift deleteEmailForwardItem(1: DeleteEmailForwardItemRequest_Thrift request) throws (
                                                                                 1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                 2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                 3: IllegalParameterException_Thrift ipe),
    ListEmailForwardItemResponse_Thrift listEmailForwardItem(1: ListEmailForwardItemRequest_Thrift request) throws (
                                                                                 1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                 2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                 3: IllegalParameterException_Thrift ipe),
    SaveMessageForwardItemResponse_Thrift saveMessageForwardItem(1: SaveMessageForwardItemRequest_Thrift request) throws (
                                                                                1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                3: IllegalParameterException_Thrift ipe),
    UpdateMessageForwardItemResponse_Thrift updateMessageForwardItem(1: UpdateMessageForwardItemRequest_Thrift request) throws (
                                                                                 1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                 2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                 3: IllegalParameterException_Thrift ipe),
    DeleteMessageForwardItemResponse_Thrift deleteMessageForwardItem(1: DeleteMessageForwardItemRequest_Thrift request) throws (
                                                                                 1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                 2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                 3: IllegalParameterException_Thrift ipe),
    ListMessageForwardItemResponse_Thrift listMessageForwardItem(1: ListMessageForwardItemRequest_Thrift request) throws (
                                                                                 1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                 2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                 3: IllegalParameterException_Thrift ipe),
    GetMessageForwardItemResponse_Thrift getMessageForwardItemByPhoneNum(1: GetMessageForwardItemRequest_Thrift request) throws (
                                                                                 1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                 2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                 3: IllegalParameterException_Thrift ipe),
    SaveOrUpdateSmtpItemResponse_Thrift saveOrUpdateSmtpItem(1: SaveOrUpdateSmtpItemRequest_Thrift request) throws (
                                                                                  1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                  2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                  3: IllegalParameterException_Thrift ipe),
    GetSmtpItemResponse_Thrift getSmtpItem(1: GetSmtpItemRequest_Thrift request) throws (
                                                                                  1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                  2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                  3: IllegalParameterException_Thrift ipe),

    CheckSmtpSendEmailResponse_Thrift checkSmtpSendEmail(1: CheckSmtpSendEmailRequest_Thrift request) throws (
                                                                                  1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                  2: shared.ServiceIsNotAvailable_Thrift sina,
                                                                                  3: SmtpSendEmailException_Thrift spe),

    ReportMaintenanceModeInfoResponse reportMaintenanceModeInfo(1: ReportMaintenanceModeInfoRequest request) throws (
                                                                                  1: shared.ServiceHavingBeenShutdown_Thrift shbsd,
                                                                                  2: shared.ServiceIsNotAvailable_Thrift sina),
 }
