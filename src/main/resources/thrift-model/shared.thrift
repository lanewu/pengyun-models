// Defining the shared data

namespace java py.thrift.share
namespace perl shared
/*
 * Structures used by the service request
 */
enum SegmentUnitStatus_Thrift {
   Start = 1, // just created, doesn't have any data, migration is needed
   ModeratorSelected = 2, // a moderator has been selected
   SecondaryEnrolled = 3, // Received a sync log request from the PrePrimary. 
   SecondaryApplicant = 4, // Want to join the segment group
   PreSecondary = 5, // the primary has accepted joining request, and accept read/write request
   PreArbiter = 6,
   PrePrimary = 7, // The group has reached consensus about this primary
   Secondary = 8, // the segment is secondary and readable/writable
   Arbiter = 9,
   Primary = 10, // the segment is primary and readable/writable
   OFFLINING = 12, // segment unit is being offlined
   OFFLINED = 13, // segment unit has been offlined
   Deleting = 14, // the segment is being deleted
   Deleted = 15, // the segment has been deleted. GC should collect this segment
   Broken = 16, // the disk which contains the segment unit is broken
   Unknown = 17
}

enum SegmentStatus_Thrift {
   Available = 1,
   UnAvailable = 2
}

enum VolumeSource_Thrift {
   CREATE=1,
   CLONE=2,
   MOVE=3,
   MOVE_ONLINE=4,
   SYNC_CLONE=5,
   LINKED_CLONE=6
}

enum SegmentUnitType_Thrift {
   Normal = 1,
   Arbiter = 2,
   Flexible = 3 // for simple configured volumes
}

enum PortalType_Thrift {
    IPV4 = 1,
    IPV6 = 2
}

enum DriverStatus_Thrift {
    START=1,
    LAUNCHING=2,
    SLAUNCHED=3,
    LAUNCHED=4,
    REMOVING=5,
    UNAVAILABLE=6,
    UNKNOWN=7,
    ERROR=8,
    RECOVERING=9,
    MIGRATING=10
}

enum LimitType_Thrift {
   Static = 1,
   Dynamic = 2
}

enum CacheType_Thrift {
   NONE = 0,
   SSD = 1
}

enum WtsType_Thrift {
   NONE = 0,
   STRONG = 1,
   WEAK = 2
}

enum VolumeType_Thrift {
   REGULAR = 1, // regular volume type, 3 nodes
   LARGE = 2, // large volume type, 5 nodes
   SMALL = 3
}

enum StoragePoolStrategy_Thrift {
    Capacity=1,
    Performance=2,
    Mixed=3
}

enum VolumeStatus_Thrift {
   ToBeCreated = 1,
   Creating = 2,
   Available = 3,
   Unavailable = 4,
   Deleting = 5,
   Deleted = 6,
   Recycling = 7, // volume is recycling from deleting or deleted status
   Fixing = 8,
   Dead = 9,
   Stable = 10,
}

enum VolumeInAction_Thrift {
    CREATING = 1,
    EXTENDING = 2,
    DELETING = 3,
    RECYCLING = 4,
    FIXING = 5,
    CLONING = 6,
    BEING_CLONED = 7,
    MOVING = 8,
    BEING_MOVED = 9,
    COPYING = 10,
    BEING_COPIED = 11,
    MOVE_ONLINE_MOVING = 12,
    MOVE_ONLINE_BEING_MOVED = 13,
    NULL = 14
}

enum DriverType_Thrift {
    NBD = 1,
    JSCSI = 2,
    ISCSI = 3,
    NFS = 4,
    FSD = 5
}

enum ServiceStatus_Thrift {
    ACTIVATING=1,
    ACTIVE=2,
    DEACTIVATING=3,
    DEACTIVE=4,
    UPGRADING=5,
    UPGRADED=6,
    ERROR=7
}

enum CheckSecondaryInactiveThresholdMode_Thrift{
    AbsoluteTime =1,
    RelativeTime =2,
}

struct ServiceMetadata_Thrift {
     1: string serviceName,
     2: ServiceStatus_Thrift serviceStatus,
     3: i32 pid,
     4: i32 pmpid,
     5: string version,
     6: string errorCause
}

struct UpgradeInfo_Thrift {
     1: bool upgrading,
     2: optional string curentVersion,
     3: optional string latestVersion
}
struct DriverKey_Thrift {
     1: i64 driverContainerId,
     2: i64 volumeId,
     3: i32 snapshotId,
     4: DriverType_Thrift driverType,

}

enum WriteUnitResult_Thrift {
    OK=1,
    OutOfRange=2,
    InputHasNoData=3,
    ChecksumMismatched=4,
}

enum ReadUnitResult_Thrift {
    OK=1,
    OutOfRange=2,
    ChecksumMismatched=3,
}

enum WriteMember_Thrift {
    Primary=1,
    Secondary=2,
    JoiningSecondary=3,
}

enum DBTableName_Thrift {
    Domain=1,
    StoragePool=2,
    VolumeRuleRelate=3,
    AccessRule=4,
    CapacityRecord=5,
}

enum AccessRuleStatusBindingVolume_Thrift {
    FREE=1,
    APPLING=2,
    APPLIED=3,
    CANCELING=4,
}
struct Tag {
   1: string key,
   2: string value
}

enum ArchiveStatus_Thrift {
    GOOD=1,
    DEGRADED=2,
    BROKEN=3,
    CONFIG_MISMATCH=4,
    OFFLINING=5,
    OFFLINED=6,
    EJECTED=7,
    INPROPERLY_EJECTED=8,
    UNKNOWN=9,
    SEPARATED=10,
}

enum ArchiveType_Thrift {
    RAW_DISK=0,
    LOG_CACHE=1,
    PAGE_READ_CACHE=2,
    WTS_DISK=3,
    PAGE_WRITE_CACHE=4,
    MIX_DISK=5,
    UNSETTLED_DISK=6,
    PAGE_CACHE=7,
}

enum StorageType_Thrift {
    SATA=1,
    SAS=2,
    SSD=3,
    PCIE=4,
}

enum SegmentUnitStatusConflictCause_Thrift {
    VolumeDeleted=1,
    VolumeRecycled=2,
    StaleSnapshotVersion=3,
    RollbackToSnapshot=4,
    VolumeExtendFailed=5,
}

enum NextAction_Thrift {
    KEEP=1,
    NEWALLOC=2,
    FREEMYSELF=3,
    CHANGE=4,
}

enum Status_Thrift {
    Available=1,
    Deleting=2,
}

enum SnapshotStatus_Thrift {
    Available = 1,
    Unavailable = 2, // the snapshot may be unavailable for lack of space of shadow page
    Deleting = 3,    // snapshot is in deleting, in this status, the shadow pages of snapshot is deleting. This status is just in data node
    Deleted = 4,
}

enum MigrationStrategy_Thrift {
     Smart = 1,
     Manual = 2
}

enum CloneType_Thrift{
    LAZY_CLONE=1,
    SYNC_CLONE=2,
    LINKED_CLONE=3,
    NONE=4
}

enum ReadWriteType_Thrift{
    READ_ONLY=1,
    READ_WRITE=2
}

enum AccessPermissionType_Thrift {
    READ=1,
    WRITE=2,
    READWRITE=3
}

struct SegId_Thrift{
   1: i64 volumeId,
   2: i32 segmentIndex
}


struct SegmentMembership_Thrift {
   1:i64 volumeId, 
   2:i32 segIndex,
   3:i32 epoch,
   4:i32 generation, 
   6:i64 primary,
   7:set<i64> secondaries,
   8:set<i64> arbiters,
   9:optional set<i64> joiningSecondaries,
   10:optional set<i64> inactiveSecondaries,
   11:optional i32 lease, // for how long the membership can be valid
   12:optional i64 tempPrimary,
   13:optional i64 secondaryCanaidate,
   14:optional i64 primaryCandidate
}

struct SegmentMembership_Switch_Thrift {
   1:i16 volumeIdSwitch,
   2:i32 segIndex,
   3:i32 epoch,
   4:i32 generation,
   6:i16 primarySwitch,
   7:set<i16> secondariesSwitch,
   8:set<i16> arbitersSwitch,
   9:optional set<i16> joiningSecondariesSwitch,
   10:optional set<i16> inactiveSecondariesSwitch,
   11:optional i32 lease, // for how long the membership can be valid
   12:optional i64 tempPrimary,
   13:optional i64 secondaryCanaidate,
   14:optional i64 primaryCandidate
}

struct ArchiveMetadata_Thrift {
   1: string devName,  // the device name
   2: i64 archiveId, 
   3: ArchiveStatus_Thrift status, // whether the disk is good to use
   4: ArchiveType_Thrift type //
   5: optional string slotNo,
   6: optional string serialNumber,
   7: optional i64 createdTime,
   8: optional i64 updatedTime,
   9: optional string updatedBy,
   10: optional string createdBy,
   11:optional i64 logicalSpace,     // logical space which can be allocated for segment unit,
   12:optional i64 logicalFreeSpace, // logical free space remain
   13:optional i64 storagePoolId,
   14:bool overloaded,
   15:StorageType_Thrift storagetype, //storage type
   16:optional i64 totalPageToMigrate,
   17:optional i64 alreadyMigratedPage,
   18:optional i64 migrationSpeed,
   19:optional i64 maxMigrationSpeed,
   20:optional list<SegId_Thrift> migrateFailedSegIdList,
   21:optional i32 freeFlexibleSegmentUnitCount,
   22:optional list<ArchiveType_Thrift> archiveTypes,
   23:optional i32 weight,
   24:optional i32 dataSizeMb,
   25:optional i64 rate,
   26:optional i64 logicalUsedSpace
}


struct SegmentUnitMetadata_Thrift {
   1:i64 volumeId, 
   2:i32 segIndex,
   3:i64 offset,
   4:SegmentMembership_Thrift membership,
   5:SegmentUnitStatus_Thrift status,
   6:SegmentUnitType_Thrift segmentUnitType
   7:i64 lastUpdated,
   8:CacheType_Thrift cacheType,
   9:optional double ratioFreePages,
   10:optional double ratioMigration,
   11:optional string volumeType, // by default, it is REGULAR
   12:optional i64 instanceId,
   13:optional string volumeMetadataJson,
   14:optional string accountMetadataJson,
   15:optional string diskName, // disk name on which the segment unit located
   16:optional i64 archiveId, // archive id of the disk
   17:optional binary snapshotManagerInBinary,
   18:optional bool isRollingBack, // is segment unit rolling back
   19:optional i32 snapshotVersion, // snapshot version
   20:optional i64 totalPageToMigrate,
   21:optional i64 alreadyMigratedPage,
   22:optional i64 migrationSpeed,
   23:optional i64 minMigrationSpeed,
   24:optional i64 maxMigrationSpeed,
   25:optional bool innerMigrating,
   26:optional map<i32, i64> snapshotCapacityMap,
   27:optional i64 snapshotTotalCapacity,
   28:optional double ratioClone,
   29: bool enableLaunchMultiDrivers,
   30: VolumeSource_Thrift volumeSource,
   31: optional CloneType_Thrift cloneType,
   32: optional i64 sourceVolumeId,
   33: optional i32 sourceSnapshotId,
}

struct SegmentUnitMetadata_Switch_Thrift {
   1:i16 volumeIdSwitch,
   2:i32 segIndex,
   3:i64 offset,
   4:SegmentMembership_Switch_Thrift membership,
   5:SegmentUnitStatus_Thrift status,
   6:SegmentUnitType_Thrift segmentUnitType
   7:i64 lastUpdated,
   8:CacheType_Thrift cacheType,
   9:optional double ratioFreePages,
   10:optional double ratioMigration,
   11:optional string volumeType, // by default, it is REGULAR
   12:optional i16 instanceIdSwitch,
   13:optional string volumeMetadataJson,
   14:optional string accountMetadataJson,
   15:optional string diskName, // disk name on which the segment unit located
   16:optional i16 archiveIdSwitch, // archive id of the disk
   17:optional binary snapshotManagerInBinary,
   18:optional bool isRollingBack, // is segment unit rolling back
   19:optional i32 snapshotVersion, // snapshot version
   20:optional i64 totalPageToMigrate,
   21:optional i64 alreadyMigratedPage,
   22:optional i64 migrationSpeed,
   23:optional i64 minMigrationSpeed,
   24:optional i64 maxMigrationSpeed,
   25:optional bool innerMigrating,
   26:optional map<i32, i64> snapshotCapacityMap,
   27:optional i64 snapshotTotalCapacity,
   28:optional double ratioClone,
   29: bool enableLaunchMultiDrivers,
   30: VolumeSource_Thrift volumeSource,
   31: optional CloneType_Thrift cloneType,
   32: optional i64 sourceVolumeId,
   33: optional i32 sourceSnapshotId,
}

struct SegmentMetadata_Thrift {
   1:i64 volumeId, 
   2:i32 segId,
   3:list<SegmentUnitMetadata_Thrift> segmentUnits,
   4:i32 indexInVolume,
   5:double freeSpaceRatio
}

struct SegmentMetadata_Switch_Thrift {
   1:i16 volumeIdSwitch,
   2:i32 segId,
   3:list<SegmentUnitMetadata_Switch_Thrift> segmentUnits,
   4:i32 indexInVolume,
   5:double freeSpaceRatio
}

struct Group_Thrift {
    1:i32 groupId
    // TODO: other fields e.g. "location", "area"
}

struct InstanceDomain_Thrift {
    1: i64 domianId
}

enum DatanodeStatus_Thrift {
    OK = 1,
    UNKNOWN = 2,
    SEPARATED = 3,
}

//datanode type:
//normal datanode: can be used to create normal segment unit or arbiter segment unit(when no enough simple datanode)
//simple datanode: only can be used to create arbiter segment unit
enum DatanodeType_Thrift {
    NORMAL = 1,
    SIMPLE = 2
}

struct InstanceMetadata_Thrift{
   1: i64 instanceId, 
   2: string endpoint,
   3: i64 capacity,
   4: i64 freeSpace,
   5: i64 logicalCapacity,
   6: list<ArchiveMetadata_Thrift> archiveMetadata,
   7: Group_Thrift group,
   8: InstanceDomain_Thrift instanceDomain,
   9: optional DatanodeStatus_Thrift datanodeStatus,
   10: DatanodeType_Thrift datanodeType
}

enum MigrationRuleStatusBindingPools_Thrift {
    FREE=1,
    APPLING=2,
    APPLIED=3,
    CANCELING=4,
}

struct MigrationRuleRelationShip_Thrift {
    1:i64 relationshipId,
    2:i64 storagePoolId,
    3:i64 ruleId,
    4:MigrationRuleStatusBindingPools_Thrift migrationRuleStatusBindingPools
}

enum MigrationRuleStatus_Thrift {
    FREE=1,
    APPLING=2,
    APPLIED=3,
    CANCELING=4,
    DELETING=5,
    AVAILABLE=6
}

struct MigrationRule_Thrift {
    1:i64 ruleId,
    2:string migrationRuleName,
    3:i64 maxMigrationSpeed,
    4:MigrationStrategy_Thrift migrationStrategy,
    5:MigrationRuleStatus_Thrift migrationRuleStatus,
    6:CheckSecondaryInactiveThresholdMode_Thrift mode,
    7:optional i64 startTime,
    8:optional i64 endTime,
    9:optional i64 waitTime,
    10:bool ignoreMissPagesAndLogs,
    11:bool builtInRule
}

struct Domain_Thrift {
    1:i64 domainId,
    2:string domainName,
    3:string domainDescription,
    4:set<i64> datanodes,
    5:set<i64> storagePoolIds,
    6:Status_Thrift status,
    7:i64 lastUpdateTime,
    8: i64 logicalSpace,
    9: i64 freeSpace
}

struct StoragePool_Thrift {
    1:i64 poolId,
    2:optional i64 domainId,
    3:optional string domainName,
    4:string poolName,
    5:optional string description,
    6:StoragePoolStrategy_Thrift strategy,
    7:map<i64, set<i64>> archivesInDatanode,
    8:set<i64> volumeIds,
    9:Status_Thrift status,
    10:i64 lastUpdateTime,
    11: i64 migrationSpeed,
    12: double migrationRatio,
    13: i64 totalSpace,
    14: i64 freeSpace,
    15: i64 logicalPSSFreeSpace,
    16: i64 logicalPSAFreeSpace,
    17: string storagePoolLevel,
    18: optional MigrationRule_Thrift migrationRule,
    19: i64 totalMigrateDataSizeMB
}

struct VolumeCloneRelationship_Thrift {
    1:i64 srcVolumeId,
    2:i64 destVolumeId,
    3:CloneType_Thrift cloneType
}

struct TotalAndUsedCapacity_Thrift {
    1:i64 totalCapacity,
    2:i64 usedCapacity
}

struct CapacityRecord_Thrift {
    1:map<string, TotalAndUsedCapacity_Thrift> capacityRecordMap
}

struct VolumeRuleRelationship_Thrift {
    1:i64 relationshipId,
    2:i64 volumeId,
    3:i64 ruleId,
    4:AccessRuleStatusBindingVolume_Thrift accessRuleStatusBindingVolume
}

struct SnapshotMetadataV2_Thrift {
    1: i32 snapshotId,
    2: string snapshotName,
    3: string snapshotDescription,
    4: i64 createdTime,
    5: i64 currentVolumeSize
}

struct SnapshotMetadata_Thrift {
    1: i32 snapshotId,
    2: string name,
    3: string description,
    4: i64 createdTime,
    5: i32 parentId,
    6: i32 childId,
    7: SnapshotStatus_Thrift status,
    8: i64 currentVolumeSize,
    9: optional i64 userDefinedSnapshotIdForOpenStack
}

/*
struct SnapshotManager_Thrift {
    1: i64 volumeId,
    2: i32 version, 
    3: i32 rollbackTimes,
    4: bool inRollbackProgress,
    5: i32 snapshotIdOfRollback,
    6: list<SnapshotMetadata_Thrift> snapshotMetadataList,
}
*/

struct VolumeMetadata_Thrift {
   1: i64 volumeId,
   2: i64 rootVolumeId,
   3: string name,
   4: string endpoint,
   5: i64 volumeSize,
   6: i64 segmentSize,
   7: i64 extendingSize,
   8: VolumeType_Thrift volumeType,
   9: CacheType_Thrift cacheType,
   10: VolumeStatus_Thrift volumeStatus,
   11: i64 accountId,
   12: list<SegmentMetadata_Thrift> segmentsMetadata,
   13: optional i64 deadTime,  // for integration test
   14: i64 domainId,
   15: bool simpleConfiguration,
   16: i32 leastSegmentUnitAtBeginning,
   17: optional binary snapshotManagerInBinary,  // snapshot information
   18: i64 storagePoolId,
   19: i32 segmentNumToCreateEachTime,
   20: string volumeLayout,
   21: double freeSpaceRatio,
   22: i64 volumeCreatedTime, // new add 2017.03.03
   23: i64 lastExtendedTime,  // new add 2017.03.03
   24: VolumeSource_Thrift volumeSource,
   25: ReadWriteType_Thrift readWrite,
   26: VolumeInAction_Thrift inAction,
   27: i32 pageWrappCount,
   28: i32 segmentWrappCount,
   29: optional i64 totalPageToMigrate,
   30: optional i64 alreadyMigratedPage,
   31: i64 migrationSpeed,
   32: double migrationRatio,
   33: bool enableLaunchMultiDrivers,
   34: bool cloneFinishStatus,
   35: double rebalanceRatio,
   36: i64 rebalanceVersion,
   37: i64 stableTime,
   38: map<i64, i16> switchStructValue,
   39: list<SegmentMetadata_Switch_Thrift> segmentsMetadataSwitch,
   40: WtsType_Thrift WtsType,
   41: i64 totalPhysicalSpace,
   42: string srcVolumeNameWithClone,
   43: string srcSnapshotNameWithClone,
   44: optional i32 cloneLayer,
   45: string eachTimeExtendVolumeSize,
   46: optional bool rollBacking,
   47: optional i32 snapshotVersion,
   48: bool markDelete,
}

struct VolumeInfoToSnapshotInfo_Thrift{
   1:i64 rootVolumeId,
   2:string rootVolumeName,
   3:i64 domainId,
   4:i64 storagePoolId,
   5:list<SnapshotMetadata_Thrift> snapshotMetadataList
}

struct SnapshotKey_Thrift{
   1:i64 rootVolumeId,
   2:i32 snapshotId
}

struct NextActionInfo_Thrift {
   1: NextAction_Thrift nextAction,
   2: optional i64 newId
}

enum RebalanceTaskType_Thrift {
   NormalRebalance=1,
   PrimaryRebalance=2
}

struct RebalanceTask_Thrift {
   1: i64 taskId,
   2: i64 destInstanceId,
   3: SegmentUnitMetadata_Thrift sourceSegmentUnit,
   4: RebalanceTaskType_Thrift taskType,
}

struct PrimaryMigrate_Thrift {
   1: SegId_Thrift segId,
   2: i64 srcInstanceId,
   3: i64 targetInstanceId
}

struct SecondaryMigrate_Thrift {
   1: SegId_Thrift segId,
   2: i64 srcInstanceId,
   3: i64 targetInstanceId,
   4: VolumeType_Thrift volumeType,
   5: CacheType_Thrift cacheType,
   6: optional string volumeMetadataJson,
   7: optional string accountMetadataJson,
   8: optional SegmentMembership_Thrift initMembership, // the initial membership, used by a new node trying to join an existing group
   9: optional list<i64> initMembers, // the initial members, used by new nodes to create a brand new volume. If initMembership is set too,
   // then initMembership has higher preference to initMembers.
   10: optional binary initSnapshotManagerInBinary, // the initial snapshot manager in byte array
   11: optional SegmentMembership_Thrift srcMembership, // the membership for src volume from which the clone volume copy page
   12: optional i32 srcSnapshotId, // the snapshot id from which the new segment unit in clone volume copy page
   13: optional CloneType_Thrift cloneType,
   14: i64 storagePoolId,
   15: SegmentUnitType_Thrift segmentUnitType,
   16: i32 segmentWrapSize,
   17: WtsType_Thrift wtsType,
   18: bool enableLaunchMultiDrivers,
   19: VolumeSource_Thrift volumeSource
}

struct ArbiterMigrate_Thrift {
   1: SegId_Thrift segId,
   2: i64 srcInstanceId,
   3: i64 targetInstanceId,
   4: VolumeType_Thrift volumeType,
   5: CacheType_Thrift cacheType,
   6: optional string volumeMetadataJson,
   7: optional string accountMetadataJson,
   8: optional SegmentMembership_Thrift initMembership, // the initial membership, used by a new node trying to join an existing group
   9: optional list<i64> initMembers, // the initial members, used by new nodes to create a brand new volume. If initMembership is set too,
   // then initMembership has higher preference to initMembers.
   10: optional binary initSnapshotManagerInBinary, // the initial snapshot manager in byte array
   11: optional SegmentMembership_Thrift srcMembership, // the membership for src volume from which the clone volume copy page
   12: optional i32 srcSnapshotId, // the snapshot id from which the new segment unit in clone volume copy page
   13: optional CloneType_Thrift cloneType,
   14: i64 storagePoolId,
   15: SegmentUnitType_Thrift segmentUnitType,
   16: i32 segmentWrapSize,
   17: WtsType_Thrift wtsType,
   18: bool enableLaunchMultiDrivers,
   19: VolumeSource_Thrift volumeSource
}

struct RebalanceTaskList_Thrift {
   1: optional list<PrimaryMigrate_Thrift> primaryMigrateList,
   2: optional list<SecondaryMigrate_Thrift> secondaryMigrateList,
   3: optional list<ArbiterMigrate_Thrift> arbiterMigrateList,
}

struct InstanceIdAndEndPoint_Thrift {
   1: i64 instanceId,
   2: string endPoint,
   3: optional i32 groupId
}

//********** Driver Qos begin**************/
enum IOLimitationStatus_Thrift {
    FREE=1,
    APPLING=2,
    APPLIED=3,
    CANCELING=4,
    DELETING=5,
    AVAILABLE=6
}

struct IOLimitationEntry_Thrift {
   1: i32 upperLimitedIOPS,
   2: i32 lowerLimitedIOPS,
   3: i64 upperLimitedThroughput,
   4: i64 lowerLimitedThroughput,
   5: string startTime,
   6: string endTime,
   7: i64 entryId;
}

struct IOLimitation_Thrift {
   1: i64 limitationId,
   2: string limitationName,
   3: LimitType_Thrift limitType,
   4: IOLimitationStatus_Thrift status,
   5: list<IOLimitationEntry_Thrift> entries;
}

struct DriverMetadata_Thrift {
   1: i64 driverContainerId,
   2: i64 volumeId,
   3: optional string volumeName,
   4: DriverType_Thrift driverType,
   5: string hostName,
   6: i32 port,
   7: DriverStatus_Thrift driverStatus,
   8: map<string,AccessPermissionType_Thrift> clientHostAccessRule,
   9: i32 coordinatorPort,
   10: i32 snapshotId,
   11: string nbdDevice,
   12: i64 instanceId,
   13: i32 processId,
   //*** driver qos id represent the relationship with IOLimitation
   //*** one driver only hava one dynamic and static IOLimitation
   14: i64 staticIOLimitationId,
   15: i64 dynamicIOLimitationId,
   16: string queryServerIp,
   17: i32 queryServerPort,
   18: string driverName,
   19: i32 chapControl,
   20: string ipv6Addr,
   21: string netIfaceName,
   22: PortalType_Thrift portalType
}

enum IOLimitationStatusBindingDrivers_Thrift {
    FREE=1,
    APPLING=2,
    APPLIED=3,
    CANCELING=4,
}

struct  IOLimitationRelationShip_Thrift {
    1:i64 relationshipId,
    2:i64 ruleId,
    3: i64 driverContainerId,
    4: i64 volumeId,
    5: DriverType_Thrift driverType,
    6: i32 snapshotId,
    7:IOLimitationStatusBindingDrivers_Thrift ioLimitationStatusBindingDrivers
}

struct ListIOLimitationsRequest {
    1:i64 requestId,
    2:i64 accountId;
}

struct ListIOLimitationsResponse {
    1:i64 requestId,
    2:list<IOLimitation_Thrift> ioLimitations;
}

struct ListIOLimitationsByDriverKeysRequest {
    1:i64 requestId,
    2:set<DriverKey_Thrift> DriverKeys;
}

struct ListIOLimitationsByDriverKeysResponse {
    1:i64 requestId,
    2:map<DriverKey_Thrift, list<IOLimitation_Thrift>> mapDriver2ItsIOLimitations
}

struct GetIOLimitationsRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:DriverKey_Thrift driverKey;
}

struct GetIOLimitationsResponse {
    1:i64 requestId,
    2:list<IOLimitation_Thrift> ioLimitations
}

struct CreateIOLimitationsRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: IOLimitation_Thrift ioLimitation;
}

struct CreateIOLimitationsResponse {
    1:i64 requestId
}

struct ApplyIOLimitationsRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<DriverKey_Thrift> driverKeys,
    4: i64 ruleId,
    5: bool commit;
}

struct ApplyIOLimitationsResponse {
    1: i64 requestId,
    2: optional list<DriverMetadata_Thrift> airDriverKeyList,
    3: string ioLimitationName,
    4: list<string> appliedDriverNames
}

struct CancelIOLimitationsRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<DriverKey_Thrift> driverKeys,
    4: i64 ruleId,
    5: bool commit;
}

struct CancelIOLimitationsResponse {
    1:i64 requestId,
    //*** current status of access rule is not allowed to cancel from some driver
    2:optional list<DriverMetadata_Thrift> airDriverKeyList,
    3: string ioLimitationName,
    4: list<string> canceledDriverNames
}

struct DeleteIOLimitationsRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:list<i64> ruleIds,
    4:bool commit;
}

struct DeleteIOLimitationsResponse {
    1:i64 requestId,
    //*** current status of IO Limitations is not allowed to delete from system
    2:optional list<IOLimitation_Thrift> airIOLimitationList,
    3: list<string> deletedIOLimitationNames
}

struct UpdateIOLimitationsRequest {
   1: i64 requestId,
   2: i64 accountId,
   3: i64 volumeId,
   4: i64 driverContainerId,
   5: DriverType_Thrift driverType,
   6: i32 snapshotId,
   7: IOLimitation_Thrift ioLimitation
}

struct UpdateIOLimitationRulesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: IOLimitation_Thrift ioLimitation;
}

struct UpdateIOLimitationsResponse {
   1: i64 requestId
}

struct GetIOLimitationAppliedDriversRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:i64 ruleId;
}

struct GetIOLimitationAppliedDriversResponse {
    1: i64 requestId,
    2: list<DriverMetadata_Thrift> driverList
}

exception IOLimitationsDuplicate_Thrift {
  1: optional string detail
}


exception IOLimitationIsDeleting{
  1: optional string detail
}

exception IOLimitationsAlreadyAppliedError {
  1: optional string detail
}

exception IOLimitationTimeInterLeaving_Thrift {
  1: optional string detail
}

exception IOLimitationsNotExists{
  1: optional string detail
}
//********** Driver Qos end*****************/



struct ListMigrationRulesRequest {
    1:i64 requestId,
    2:i64 accountId;
}

struct ListMigrationRulesResponse {
    1:i64 requestId,
    2:list<MigrationRule_Thrift> migrationRules;
}

struct ListMigrationRulesByStoragePoolIdsRequest {
    1:i64 requestId,
    2:set<i64> storagePoolIds;
}

struct ListMigrationRulesByStoragePoolIdsResponse {
    1:i64 requestId,
    2:map<i64, list<MigrationRule_Thrift>> migrationRulesTable;
}

struct GetMigrationRulesRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:i64 storagePoolId;
}

struct GetMigrationRulesResponse {
    1:i64 requestId,
    2:list<MigrationRule_Thrift> accessRules
}

struct CreateMigrationRulesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: MigrationRule_Thrift migrationRule
}

struct CreateMigrationRulesResponse {
    1: i64 requestId
}

struct UpdateMigrationRulesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: MigrationRule_Thrift migrationRule
}

struct UpdateMigrationRulesResponse {
    1: i64 requestId
    2: optional list<MigrationRule_Thrift> airMigrationRuleList
}

struct ApplyMigrationRulesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<i64> storagePoolIds,
    4: i64 ruleId,
    5: bool commit
}

struct ApplyMigrationRulesResponse {
    1: i64 requestId,
    //*** current status of access rule is not allowed to apply to some volume
    2: optional list<StoragePool_Thrift> airStoragePoolList,
    3: string ruleName,
    4: list<string> appliedStoragePoolNames
}

struct CancelMigrationRulesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<i64> storagePoolIds,
    4: i64 ruleId,
    5: bool commit
}

struct CancelMigrationRulesResponse {
    1: i64 requestId,
    //*** current status of access rule is not allowed to cancel from some volume
    2: optional list<StoragePool_Thrift> airStoragePoolList
    3: string ruleName,
    4: list<string> canceledStoragePoolNames
}

struct DeleteMigrationRulesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<i64> ruleIds,
    4: bool commit;
}

struct DeleteMigrationRulesResponse {
    1: i64 requestId,
    //*** current status of rules is not allowed to delete from system
    2: optional list<MigrationRule_Thrift> airMigrationRuleList
    3: list<string> deletedRuleNames
}

struct GetAppliedStoragePoolsRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 ruleId;
}

struct GetAppliedStoragePoolsResponse {
    1: i64 requestId,
    2: list<StoragePool_Thrift> StoragePoolList;
}

exception MigrationRuleDuplicate_Thrift {
  1: optional string detail
}

exception MigrationRuleIsDeleting{
  1: optional string detail
}

exception MigrationRuleAlreadyAppliedError {
  1: optional string detail
}

exception MigrationRuleNotExists{
  1: optional string detail
}

//********** Launch Driver Request *************/
struct LaunchDriverRequest_Thrift {
    1: i64 requestId,
    2: string driverName,
    3: i64 accountId,
    4: i64 volumeId,
    5: i32 snapshotId,
    6: DriverType_Thrift driverType,
    //***the amount of driver to launch for a volume
    //***driver amount is required due to multiple path to access driver is allowed
    7: i32 driverAmount,
    8: optional string hostName //could launch on special driver host, one path
}

struct LaunchDriverResponse_Thrift {
    1: i64 requestId,
    2: set<i64> relatedDriverContainerIds;
}

struct LaunchScsiDriverRequest_Thrift {
    1: i64 requestId,
    2: i64 accountId,
    3: map<i64, i32> volumesForLaunch,
    4: DriverType_Thrift driverType,
    //***the amount of driver to launch for a volume
    //***driver amount is required due to multiple path to access driver is allowed
    5: i32 driverAmount,
    6: optional string hostName, //could launch on special driver host, one path
    7: string scsiIp
}
//*********** End *****************************/

struct ListIscsiAppliedAccessRulesRequest_Thrift{
    1: i64 requestId,
    2: DriverKey_Thrift driverKey
}

struct ListIscsiAppliedAccessRulesResponse_Thrift{
    1: i64 requestId,
    2: list<string> initiatorNames
}

enum BroadcastLogStatus_Thrift {
    Creating=1,
    Created=2,
    Committed=3,
    Abort=4,
    AbortConfirmed=5
}

struct BroadcastLog_Thrift {
    1: i64 logUUID,
    2: i64 logId,
    3: i64 offset,
    4: i64 checksum,
    5: i32 length,
    6: BroadcastLogStatus_Thrift logStatus,
    7: i32 snapshotVersion,
}

struct GetLatestLogsRequest_Thrift {
    1: i64 requestId,
    2: list<SegId_Thrift> segIdList,
    3: bool needRemoveLogsInSecondary
}

struct GetLatestLogsResponse_Thrift {
    1: i64 requestId,
    2: map<SegId_Thrift, list<BroadcastLog_Thrift>> mapSegIdToLogs
}

struct CommitLogsRequest_Thrift {
    1: i64 requestId,
    2: SegmentMembership_Thrift membership,
    3: map<i64, list<BroadcastLog_Thrift>> mapRequestIdToLogs
}

struct CommitLogsResponse_Thrift {
    1: i64 requestId,
    2: i32 segIndex,
    3: string endPoint,
    4: map<i64, list<BroadcastLog_Thrift>> mapRequestIdToLogs,
    5: optional WriteMember_Thrift writeMember,
    6: optional bool onError
}

struct ConfirmAbortLogsRequest_Thrift {
    1: i64 requestId,
    2: SegId_Thrift segId,
    3: i64 fromLogId,
    4: i64 toLogId
}

struct ConfirmAbortLogsResponse_Thrift {
    1: i64 requestId,
    2: bool success,
    3: optional i64 fromLogId
}

//********** Access rules begin              ********/
//********** Get Volume Access Rules Request ********/
enum AccessRuleStatus_Thrift {
    FREE=1,
    APPLING=2,
    APPLIED=3,
    CANCELING=4,
    DELETING=5,
    AVAILABLE=6
}

struct VolumeAccessRule_Thrift {
    1: i64 ruleId,
    2: string incomingHostName,
    3: AccessPermissionType_Thrift permission,
    4: AccessRuleStatus_Thrift status
}

struct ListVolumeAccessRulesRequest {
    1:i64 requestId,
    2:i64 accountId;
}

struct ListVolumeAccessRulesResponse {
    1:i64 requestId,
    2:list<VolumeAccessRule_Thrift> accessRules
}

struct ListVolumeAccessRulesByVolumeIdsRequest {
    1:i64 requestId,
    2:set<i64> volumeIds
}

struct ListVolumeAccessRulesByVolumeIdsResponse {
    1:i64 requestId,
    2:map<i64, list<VolumeAccessRule_Thrift>> accessRulesTable
}

struct GetVolumeAccessRulesRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:i64 volumeId;
}

struct GetVolumeAccessRulesResponse {
    1:i64 requestId,
    2:list<VolumeAccessRule_Thrift> accessRules
}

struct CreateVolumeAccessRulesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<VolumeAccessRule_Thrift> accessRules,
    4: bool forScsiClien
}

struct CreateVolumeAccessRulesResponse {
    1:i64 requestId,
    2:i64 ruleId
}

struct ApplyVolumeAccessRulesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 volumeId,
    4: list<i64> ruleIds,
    5: bool commit;
}

struct ApplyVolumeAccessRulesResponse {
    1:i64 requestId,
    //*** current status of access rule is not allowed to apply to some volume
    2:optional list<VolumeAccessRule_Thrift> airAccessRuleList;
}

struct ApplyVolumeAccessRuleOnVolumesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<i64> volumeIds,
    4: i64 ruleId,
    5: bool commit;
}

struct ApplyVolumeAccessRuleOnVolumesResponse {
    1:i64 requestId,
    2:optional list<VolumeMetadata_Thrift> airVolumeList;
}

struct CancelVolumeAccessRulesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 volumeId,
    4: list<i64> ruleIds,
    5: bool commit;
}

struct CancelVolumeAccessRulesResponse {
    1:i64 requestId,
    //*** current status of access rule is not allowed to cancel from some volume
    2:optional list<VolumeAccessRule_Thrift> airAccessRuleList;
}


struct CancelVolAccessRuleAllAppliedRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<i64> volumeIds,
    4: i64 ruleId,
    5: bool commit;
}

struct CancelVolAccessRuleAllAppliedResponse {
    1:i64 requestId,
    2:optional list<i64> airVolumeIds;
}

struct ApplyVolumeAccessRulesToDriverRequest {
    1:i64 requestId,
    2:list<VolumeAccessRule_Thrift> applyVolumeAccessRules;
}

struct ApplyVolumeAccessRulesToDriverResponse {
    1:i64 requestId,
}

struct CancelVolumeAccessRulesToDriverRequest {
    1:i64 requestId,
    2:list<VolumeAccessRule_Thrift> cancelVolumeAccessRules;
}

struct CancelVolumeAccessRulesToDriverResponse {
    1:i64 requestId,
}

struct DeleteVolumeAccessRulesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<i64> ruleIds,
    4: bool commit;
}

struct DeleteVolumeAccessRulesResponse {
    1: i64 requestId,
    //*** current status of access rule is not allowed to delete from system
    2: optional list<VolumeAccessRule_Thrift> airAccessRuleList
}

struct GetAppliedVolumesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 ruleId;
}

struct GetAppliedVolumesResponse {
    1: i64 requestId,
    2: list<i64> volumeIdList
}

exception AccessRuleNotApplied_Thrift {
    1: optional string detail
}

exception AccessRuleNotFound_Thrift {
    1: optional string detail
}

exception AccessRuleUnderOperation_Thrift {
    1: optional string detail
}

//********** Get Iscsi Volume Access Rules Request ********/
struct IscsiAccessRule_Thrift {
    1: i64 ruleId,
    2: string ruleNotes,
    3: string initiatorName,
    4: string user,
    5: string passed,
    6: string outUser,
    7: string outPassed,
    8: AccessPermissionType_Thrift permission,
    9: AccessRuleStatus_Thrift status
}

struct IscsiRuleRelationship_Thrift {
    1:i64 relationshipId,
    2:DriverKey_Thrift driverKey,
    3:i64 ruleId,
    4:AccessRuleStatusBindingVolume_Thrift accessRuleStatusBindingVolume
}


struct ListIscsiAccessRulesRequest {
    1:i64 requestId,
    2:i64 accountId,
}

struct ListIscsiAccessRulesResponse {
    1:i64 requestId,
    2:list<IscsiAccessRule_Thrift> accessRules
}

struct ListIscsiAccessRulesByDriverKeysRequest {
    1:i64 requestId,
    2:set<DriverKey_Thrift> DriverKeys
}

struct ListIscsiAccessRulesByDriverKeysResponse {
    1:i64 requestId,
    2:map<DriverKey_Thrift, list<IscsiAccessRule_Thrift>> accessRulesTable
}

struct GetIscsiAccessRulesRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:DriverKey_Thrift driverKey
}

struct GetIscsiAccessRulesResponse {
    1:i64 requestId,
    2:list<IscsiAccessRule_Thrift> accessRules
}

struct ReportIscsiAccessRulesRequest {
   1:i64 requestId,
   2:DriverKey_Thrift driverKey,
   3:list<IscsiAccessRule_Thrift> accessRules
}

struct ReportIscsiAccessRulesResponse {
   1:i64 requestId,
}

struct CreateIscsiAccessRulesRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<IscsiAccessRule_Thrift> accessRules
}

struct CreateIscsiAccessRulesResponse {
    1:i64 requestId
}

struct ApplyIscsiAccessRulesRequest {
    1: i64 requestId,
    2:i64 accountId,
    3: DriverKey_Thrift driverKey,
    4: list<i64> ruleIds,
    5: bool commit
}

struct ApplyIscsiAccessRulesResponse {
    1:i64 requestId,
    //*** current status of access rule is not allowed to apply to some volume
    2:optional list<IscsiAccessRule_Thrift> airAccessRuleList;
}


struct ApplyIscsiAccessRuleOnIscsisRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:list<DriverKey_Thrift> driverKeys,
    4:i64 ruleId,
    5:bool commit
}

struct ApplyIscsiAccessRuleOnIscsisResponse {
    1:i64 requestId,
    2:optional list<DriverKey_Thrift> airDriverKeyList;
}


struct CancelDriversRulesRequest {
    1:i64 requestId,
    2:DriverKey_Thrift driverKey;
}

struct CancelDriversRulesResponse {
    1:i64 requestId;
}


struct CancelIscsiAccessRulesRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:DriverKey_Thrift driverKey,
    4:list<i64> ruleIds,
    5:bool commit
}

struct CancelIscsiAccessRulesResponse {
    1:i64 requestId,
    //*** current status of access rule is not allowed to cancel from some driver
    2:optional list<IscsiAccessRule_Thrift> airAccessRuleList;
}

struct CancelIscsiAccessRuleAllAppliedRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:list<DriverKey_Thrift> driverKeys,
    4:i64 ruleId,
    5:bool commit
}

struct CancelIscsiAccessRuleAllAppliedResponse {
    1:i64 requestId,
    2:optional list<DriverKey_Thrift> airDriverKeyList;
}

struct ApplyIscsiAccessRulesToDriverRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:list<IscsiAccessRule_Thrift> applyIscsiAccessRules;
}

struct ApplyIscsiAccessRulesToDriverResponse {
    1:i64 requestId,
}

struct CancelIscsiAccessRulesToDriverRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:list<IscsiAccessRule_Thrift> cancelIscsiAccessRules;
}

struct CancelIscsiAccessRulesToDriverResponse {
    1:i64 requestId,
}

struct DeleteIscsiAccessRulesRequest {
    1: i64 requestId,
    2:i64 accountId,
    3: list<i64> ruleIds,
    4: bool commit
}

struct DeleteIscsiAccessRulesResponse {
    1: i64 requestId,
    //*** current status of access rule is not allowed to delete from system
    2: optional list<IscsiAccessRule_Thrift> airAccessRuleList
}


struct GetAppliedIscsisRequest {
    1: i64 requestId,
    2:i64 accountId,
    3: i64 ruleId;
}

struct GetAppliedIscsisResponse {
    1: i64 requestId,
    2: list<DriverMetadata_Thrift> driverList
    //*** 2: list<DriverKey_Thrift> driverKeyList
//    2:list<i64> volumeIdList
}

enum AccessRuleStatusBindingIscsi_Thrift {
    FREE=1,
    APPLING=2,
    APPLIED=3,
    CANCELING=4,
}

exception IscsiBeingDeletedException_Thrift {
  1: optional string detail
}

exception RootIscsiBeingDeletedException_Thrift {
  1: optional string detail
}


exception IscsiAccessRuleDuplicate_Thrift {
  1: optional string detail
}

exception IscsiAccessRuleFormatError_Thrift {
  1: optional string detail
}

exception ChapSameUserPasswdError_Thrift {
  1: optional string detail
}

exception IscsiAccessRuleNotFound_Thrift {
  1: optional string detail
}

exception IscsiAccessRuleUnderOperation_Thrift {
  1: optional string detail
}

exception IscsiNotFoundException_Thrift {
  1: optional string detail
}

exception IscsiUnderOperationException_Thrift {
  1: optional string detail
}
//**********  Access rules end  **********/

//**********  SCSI start *****************/
enum ScsiDeviceStatus_Thrift {
    CREATING=1,
    NORMAL=2,
    RECOVERY=3,
    UMOUNT=4,
    ERROR=5,
    CONNECT_EXCEPTION_RECOVERING = 6,
    LAUNCHING = 7,
    UNKNOWN = 8,
    REMOVING = 9,
    CONNECTING = 10,
    DISCONNECTING = 11

}

struct MountScsiDeviceRequest {
    1:i64 requestId,
    2:i64 volumeId,
    3:i32 snapshotId,
    4:string driverIp;
}

struct MountScsiDeviceResponse {
    1:i64 requestId,
    2:i64 driverContainerIdForScsi
}

struct UmountScsiDeviceRequest {
    1:i64 requestId,
    2:i64 volumeId,
    3:i32 snapshotId,
    4:string driverIp;
}

struct UmountScsiDeviceResponse {
    1:i64 requestId;
}

/****/
exception NoEnoughPydDeviceException_Thrift {
    1: optional string detail
}

exception ConnectPydDeviceOperationException_Thrift {
    1: optional string detail
}

exception CreateBackstoresOperationException_Thrift {
    1: optional string detail
}

exception CreateLoopbackOperationException_Thrift {
    1: optional string detail
}

exception CreateLoopbackLunsOperationException_Thrift {
    1: optional string detail
}

exception GetScsiDeviceOperationException_Thrift {
    1: optional string detail
}

exception ScsiDeviceIsLaunchException_Thrift {
    1: optional string detail
}

exception InfocenterServerException_Thrift {
    1: optional string detail
}

exception CreateVolumeAccessRulesException_Thrift {
    1: optional string detail
}

exception ApplyVolumeAccessRuleException_Thrift {
    1: optional string detail
}

exception GetPydDriverStatusException_Thrift {
    1: optional string detail
}

exception GetScsiClientException_Thrift {
    1: optional string detail
}

exception CanNotGetPydDriverException_Thrift {
    1: optional string detail
}

//**********  SCSI end *****************/

struct GetConnectClientInfoRequest {
    1:i64 requestId,
    2:i64 volumeId;
}

struct GetConnectClientInfoResponse {
    1:i64 requestId,
    2:map<string, AccessPermissionType_Thrift> connectClientAndAccessType;
}


struct GetCapacityRequest {
    1:i64 requestId,
    2:i64 accountId;
}

struct GetCapacityResponse {
    1:i64 requestId,
    2:i64 capacity,
    3:i64 freeSpace,
    4:i64 logicalCapacity
}



//********** end ***********/

//*********** license store start *****************************/
struct LicenseCryptogramInformation_Thrift {
    1:i64 id,
    2:binary license,
    3:binary age,
    4:binary signature
}

//*********** license store End *****************************/

//************** fix volume ******************/
enum SegmentUnitRole_Thrift {
   Primary=1,
   Secondary=2,
   JoiningSecondary=3,
   Arbiter=4,
}

struct FixVolumeRequest_Thrift {
   1:i64 requestId,
   2:i64 volumeId,
   3:i64 accountId,
}

exception VolumeFixingOperationException_Thrift {
  1: optional string detail
}

struct FixVolumeResponse_Thrift {
   1:i64 requestId,
   2:bool needFixVolume,
   3:bool fixVolumeCompletely,
   4:set<i64> lostDatanodes,
}

struct CreateSegmentUnitInfo {
   1:SegmentUnitRole_Thrift segmentUnitRole,
   2:map<InstanceIdAndEndPoint_Thrift,SegmentMembership_Thrift> segmentMembershipMap;
}

struct ConfirmFixVolumeRequest_Thrift {
   1:i64 requestId,
   2:i64 volumeId,
   3:i64 accountId,
   4:optional set<i64> lostDatanodes,
}

struct ConfirmFixVolumeResponse_Thrift {
   1:i64 responseId,
   2:bool confirmFixVolumeSucess,
}

struct ConfirmFixVolumeResponse{
   1:i64 responseId,
   2:i64 storagePoolId,
   3:VolumeType_Thrift volumeType,
   4:CacheType_Thrift cacheType,
   5:map<SegId_Thrift, list<CreateSegmentUnitInfo>> createSegmentUnits,
   6:VolumeSource_Thrift volumeSource
}

//************** fix volume end **************/
struct DriverIpTarget_Thrift {
        1:i32 snapshotId,
        2:string driverIp,
        3:DriverType_Thrift driverType,
        4:i64 driverContainerId
}

struct UmountDriverRequest_Thrift {
    1:i64 requestId,
    2:i64 accountId,
    3:i64 volumeId,
    4:optional list<DriverIpTarget_Thrift> driverIpTargetList     // If the scope is used, then umount drivers with specified ips
                                                                                                               // Otherwise, umount all drivers binding to the volume
}
struct UmountDriverResponse_Thrift {
    1:i64 requestId,
    2:list<DriverIpTarget_Thrift> driverIpTarget
}

enum ScsiClientOperationException_Thrift {
    ScsiClientHaveLaunchedVolumeException_Thrift = 1,
    NetworkException_Thrift = 2,
    VolumeLaunchingException_Thrift = 3,
    VolumeUmountingException_Thrift = 4
}

struct UmountScsiDriverRequest_Thrift {
    1:i64 requestId,
    2:i64 accountId,
    3:map<i64, i32> volumesForUmount,
    5:string scsiClientIp
}

struct UmountScsiDriverResponse_Thrift {
    1:i64 requestId,
    2: map<string, ScsiClientOperationException_Thrift> error
}

struct ChangeDriverBoundVolumeRequest {
    1: i64 requestId,
    2: DriverKey_Thrift driver,
    3: i64 newVolumeId
}
struct ChangeDriverBoundVolumeResponse {
    1: i64 requestId
}

struct GetPerformanceParameterRequest_Thrift {
   1: i64 requestId,
   2: i64 volumeId,
   3: i32 snapshotId,
   4: DriverType_Thrift driverType
}

struct GetPerformanceFromPYMetricsResponse_Thrift {
   1: i64 requestId,
   2: i64 volumeId,
   3: map<i64, i64> writeThroughput,
   4: map<i64, i64> readThroughput,
   5: map<i64, i64> readIOPS,
   6: map<i64, i64> writeIOPS,
   7: i64 writeLatency,
   8: i64 readLatency,
}

struct GetStoragePerformanceParameterRequest_Thrift {
   1: i64 requestId,
   2: i64 domainId,
   3: i64 storageId
}

struct GetStoragePerformanceFromPYMetricsResponse_Thrift {
   1: i64 requestId,
   2: i64 storageId,
   3: i64 domainId,
   4: map<i64, i64> writeThroughput,
   5: map<i64, i64> readThroughput,
   6: map<i64, i64> readIOPS,
   7: map<i64, i64> writeIOPS,
   8: i64 writeLatency,
   9: i64 readLatency
}

struct GetPerformanceResponse_Thrift {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 writeThroughput,
   4: i64 readThroughput,
   5: i64 readIOPS,
   6: i64 writeIOPS,
   7: i64 writeLatency,
   8: i64 readLatency,
}

struct GetPerformanceParameterResponse_Thrift {
   1: i64 requestId,
   2: i64 volumeId,
   3: i64 readCounter,
   4: i64 writeCounter,
   5: i64 readDataSizeBytes,
   6: i64 writeDataSizeBytes,
   7: i64 readLatencyNS,
   8: i64 writeLatencyNS,
   9: i64 recordTimeIntervalMS,
}

struct GetCapacityRecordRequest_Thrift {
   1: i64 requestId,
   2: i64 accountId;
}

struct GetCapacityRecordResponse_Thrift {
   1: i64 requestId,
   2: CapacityRecord_Thrift capacityRecord
}

struct CreateDefaultDomainAndStoragePoolRequest_Thrift {
   1: i64 requestId,
   2: i64 accountId
}

struct CreateDefaultDomainAndStoragePoolResponse_Thrift {
   1: i64 requestId
}


//********** Start of setting configuration ************/
struct SetConfigurationsRequest {
  1:i64 requestId,
  2:map<string, string> configurations
}

struct SetConfigurationsResponse {
  1:i64 requestId, 
  // if a configuration is set successfully, the value of the map is "ok", otherwise the value is "the failure reason"
  2:map<string, string> results 
}

//********** Start of getting configuration ************/
struct GetConfigurationsRequest {
  1:i64 requestId,
  2:optional set<string> keys 
}

struct GetConfigurationsResponse {
  1:i64 requestId, 
  // if a configuration is set successfully, the value of the map is "ok", otherwise the value is "the failure reason"
  2:map<string, string> results 
}



//******** start of disk lauching ********************/
struct OnlineDiskRequest {
  1: i64 requestId, 
  2: i64 accountId,
  3: InstanceMetadata_Thrift instance
  4: ArchiveMetadata_Thrift onlineArchive
}
struct OnlineDiskResponse {
  1: i64 requestId
}

struct OfflineDiskRequest {
  1: i64 requestId, 
  2: i64 accountId,
  3: InstanceMetadata_Thrift instance,
  4: ArchiveMetadata_Thrift offlineArchive
}
struct OfflineDiskResponse {
  1: i64 requestId
}

struct SettleArchiveTypeRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 archiveId,
    4: string devName,  // the device name
    5: InstanceMetadata_Thrift instance,
    6: list<ArchiveType_Thrift> archiveTypes
}
struct SettleArchiveTypeResponse {
    1: i64 requestId
}
//********** for test only***************************/
struct SetIOErrorRequest {
  1: i64 requestId, 
  2: i64 archiveId,
  3: i32 errorCount,
  4: optional ArchiveType_Thrift archiveType
}

struct SetIOErrorResponse {
  1: i64 requestId
}

struct SetArchiveConfigRequest {
  1: i64 archiveId,
  2: optional i64 instanceId,
  3: optional i32 groupId,
  4: optional i64 segmentSize,
  5: optional i32 pageSize,
  6: i64 requestId
}


struct SetArchiveConfigResponse {
  1: i64 requestId
}
//********* end of disk launching *****************/


//******** domain begin **********************/
struct CreateDomainRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:Domain_Thrift domain;
}
struct CreateDomainResponse {
    1:i64 requestId,
    2:Domain_Thrift domainThrift,
    3:optional list<i64> addedDatanodes
}
struct UpdateDomainRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:Domain_Thrift domain;
}
struct UpdateDomainResponse {
    1:i64 requestId,
    2:optional list<i64> addedDatanodes
}
struct RemoveDatanodeFromDomainRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:i64 domainId,
    4:i64 datanodeInstanceId
}
struct RemoveDatanodeFromDomainResponse {
    1:i64 requestId,
    2:string domainName
}
struct DeleteDomainRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:i64 domainId;
}
struct DeleteDomainResponse {
    1:i64 requestId,
    2:string domainName,
    3:optional list<i64> removedDatanode
}
struct ListDomainRequest {
    1:i64 requestId,
    2:i64 accountId,
    3:optional list<i64> domainIds
}
struct OneDomainDisplay_Thrift {
    1: Domain_Thrift domainThrift,
    2: list<InstanceMetadata_Thrift> datanodes
}
struct ListDomainResponse {
    1:i64 requestId,
    2:list<OneDomainDisplay_Thrift> domainDisplays
}
//******* domain end ************************/


//******* storagepool begin *****************/
struct CreateStoragePoolRequest_Thrift {
    1:i64 requestId,
    2:i64 accountId,
    3:StoragePool_Thrift storagePool
}
struct CreateStoragePoolResponse_Thrift {
    1:i64 requestId,
    2:StoragePool_Thrift storagePoolThrift,
    3:optional map<i64, list<i64>> datanodeMapAddedArchives
}
struct UpdateStoragePoolRequest_Thrift {
    1:i64 requestId,
    2:i64 accountId,
    3:StoragePool_Thrift storagePool
}
struct UpdateStoragePoolResponse_Thrift {
    1:i64 requestId,
    2:optional map<i64, list<i64>> datanodeMapAddedArchives
}
struct RemoveArchiveFromStoragePoolRequest_Thrift {
    1:i64 requestId,
    2:i64 accountId,
    3:i64 datanodeInstanceId,
    4:i64 archiveId,
    5:i64 domainId,
    6:i64 storagePoolId
}
struct RemoveArchiveFromStoragePoolResponse_Thrift {
    1:i64 requestId,
    2:string storagePoolName
}
struct DeleteStoragePoolRequest_Thrift {
    1:i64 requestId,
    2:i64 accountId,
    3:i64 domainId,
    4:i64 storagePoolId
}
struct DeleteStoragePoolResponse_Thrift {
    1:i64 requestId,
    2:string storagePoolName,
    3:optional map<i64, list<i64>> datanodeMapRemovedArchiveIds
}
struct ListStoragePoolRequest_Thrift {
    1:i64 requestId,
    2:i64 accountId,
    3:optional i64 domainId,
    4:optional list<i64> storagePoolIds
}
struct OneStoragePoolDisplay_Thrift {
    1: StoragePool_Thrift storagePoolThrift,
    2: list<ArchiveMetadata_Thrift> archiveThrifts
}
struct ListStoragePoolResponse_Thrift {
    1:i64 requestId,
    2:list<OneStoragePoolDisplay_Thrift> storagePoolDisplays
}
//****** storagepool end ******************/

//****** add set or free archives and datanode ******/
struct SetDatanodeDomainRequest_Thrift {
    1:i64 requestId,
    2:i64 domainId
}
struct SetDatanodeDomainResponse_Thrift {
    1:i64 requestId
}
struct FreeDatanodeDomainRequest_Thrift {
    1:i64 requestId
}
struct FreeDatanodeDomainResponse_Thrift {
    1:i64 requestId
}

struct SetArchiveStoragePoolRequest_Thrift {
    1:i64 requestId,
    2:map<i64, i64> archiveIdMapStoragePoolId
}
struct SetArchiveStoragePoolResponse_Thrift {
    1:i64 requestId
}
struct FreeArchiveStoragePoolRequest_Thrift {
    1:i64 requestId,
    2:list<i64> freeArchiveList
}
struct FreeArchiveStoragePoolResponse_Thrift {
    1:i64 requestId
}
//****** end set or free archives and datanode ******/


//******************** storage pool capacity begin ****************/
struct StoragePoolCapacity_Thrift {
    1:i64 domainId,
    2:i64 storagePoolId,
    3:string storagePoolName,
    4:i64 freeSpace,
    5:i64 totalSpace,
    6:i64 usedSpace
}

struct ListStoragePoolCapacityRequest_Thrift {
    1:i64 requestId,
    2:i64 accountId,
    3:i64 domainId,
    4:optional list<i64> storagePoolIdList
}
struct ListStoragePoolCapacityResponse_Thrift {
    1:i64 requestId,
    2:list<StoragePoolCapacity_Thrift> storagePoolCapacityList
}

//******************** storage pool capacity end ******************/


//******************** operation begin ****************/
struct Operation_Thrift {
    1:  i64 operationId,
    2:  i64 targetId,
    3:  string operationTarget,
    4:  i64 startTime,
    5:  i64 endTime,
    6:  string description,
    7:  string status,
    8:  i64 progress,
    9:  string errorMessage,
    10: i64 accountId,
    11: string operationType,
    12: string targetName,
    13: i64 targetSourceSize,
    14: list<string> endPointListString,
    15: i32 snapshotId,
    16: string accountName,
    17: string operationObject
}

struct ListOperationsRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: optional list<i64> operationIds,
    4: optional string accountName,
    5: optional string operationType,
    6: optional string targetType,
    7: optional string targetName,
    8: optional string status,
    9: optional i64 startTime,
    10: optional i64 endTime
}
struct ListOperationsResponse {
    1:i64 requestId,
    2:list<Operation_Thrift> operationList
}

//******************** operation end ******************/

/// for snapshot
struct CreateSnapshotRequest {
    1:i64 requestId,
    2:i64 volumeId,
    3:string snapshotName,
    4:string description,
    5:i64 createdTime,
    6:i32 version,
    7:i64 accountId,
    // this field is optional, when console create snapshot id, it does not know the snapshot id and control center will allocate id
    8:optional i32 snapshotId,
    9:i64 currentVolumeSize,
    10:optional i64 userDefinedSnapshotIdForOpenStack,
}

struct CreateSnapshotResponse {
    1:i64 requestId,
    2:optional i32 snapshotId,  // id of snapshot of created
    3:optional i32 version,    // version of the updated snapshot manager
}

struct RollbackFromSnapshotRequest {
    1:i64 requestId,
    2:i64 volumeId,
    3:i32 snapshotId,
    4:i64 accountId,
    5:i32 version
}

struct RollbackFromSnapshotResponse {
    1:i64 requestId,
    2:i32 version
}

struct DeleteSnapshotRequest {
    1:i64 requestId,
    2:i64 volumeId,
    3:i32 snapshotId,
    4:i64 accountId,
    5:i32 version
}

struct DeleteSnapshotResponse {
    1:i64 requestId,
    2:i32 version
}

struct UpdateSnapshotRequest {
    1:i64 requestId,
    2:i64 volumeId,
    3:binary snapshotManagerInBinary
}

struct UpdateSnapshotResponse {
    1:i64 requestId,
    2:i32 version
}

struct UpdateSnapshotVersionRequest {
    1:i64 requestId,
    2:i64 volumeId,
    3:i32 version
}

struct UpdateSnapshotVersionResponse {
    1:i64 requestId,
    2:i64 newVolumeId,
    3:optional i32 snapshotId // id of snapshot of created
}

struct DiskSmartInfo_Thrift{
    1: string id,
    2: string attributeName_EN,
    3: string attributeName_CN,
    4: string flag,
    5: string value,
    6: string worst,
    7: string thresh,
    8: string type,
    9: string updated,
    10: string whenFailed,
    11: string rawValue;
}

struct HardDiskInfo_Thrift{
    1: string name,
    2: optional string ssdOrHdd,
    3: optional string vendor,
    4: optional string model,
    5: optional string sn,
    6: optional i64 rate,
    7: optional string size,
    8: optional string wwn,
    9: optional string controllerId,
    10: optional string slotNumber,
    11: optional string enclosureId,
    12: optional string cardType,
    13: optional string swith,
    14: optional string serialNumber,
    15: optional string id,
    16: optional list<DiskSmartInfo_Thrift> smartInfo,
}

struct SensorInfo_Thrift{
    1: string name,
    2: string value,
    3: string status
}

struct ServerNode_Thrift{
    1: string serverId,
    2: string hostName,
    3: string modelInfo,
    4: string cpuInfo,
    5: string memoryInfo,
    6: string diskInfo,
    7: string networkCardInfo,
    8: string networkCardInfoName,
    9: string manageIp,
    10: string gatewayIp,
    11: string storeIp,
    12: string rackNo,
    13: string slotNo,
    14: string status,
    15: string childFramNo,
    16: set<HardDiskInfo_Thrift> diskInfoSet,
    17: DatanodeStatus_Thrift datanodeStatus,
    18: set<SensorInfo_Thrift> sensorInfos
}

struct ReportServerNodeInfoRequest_Thrift{
    1: i64 requestId,
    2: string serverId,
    3: string hostName,
    4: optional string modelInfo,
    5: optional string cpuInfo,
    6: optional string memoryInfo,
    7: optional string diskInfo,
    8: optional string networkCardInfo,
    9: optional string networkCardInfoName,
    10: optional set<HardDiskInfo_Thrift> hardDisks,
    11: optional string manageIp,
    12: optional string gatewayIp,
    13: optional string storeIp,
    14: optional string rackNo,
    15: optional string slotNo,
    16: optional set<SensorInfo_Thrift> sensorInfos,
}

struct ReportServerNodeInfoResponse_Thrift{
    1: i64 responseId
}

struct UpdateServerNodeRequest_Thrift {
    1: i64 requestId,
    2: string serverId,
    3: optional string modelInfo,
    4: optional string cpuInfo,
    5: optional string memoryInfo,
    6: optional string diskInfo,
    7: optional string networkCardInfo,
    8: optional string networkCardInfoName,
    9: optional string manageIp,
    10: optional string gatewayIp,
    11: optional string storeIp,
    12: optional string rackNo,
    13: optional string slotNo,
    14: optional string childFramNo,
    15: i64 accountId,
    16: string hostname
}

struct UpdateServerNodeResponse_Thrift {
    1: i64 responseId
}

struct DeleteServerNodesRequest_Thrift {
    1: i64 accountId,
    2: i64 requestId,
    3: list<string> serverIds
}

struct DeleteServerNodesResponse_Thrift {
    1: i64 responseId,
    2: list<string> deletedServerNodeHostnames
}

struct ListServerNodesRequest_Thrift {
    1: i64 requestId,
    2: i32 limit,
    3: optional i32 page,
    4: optional string sortField,
    5: optional string sortDirection,
    6: optional string hostName,
    7: optional string modelInfo,
    8: optional string cpuInfo,
    9: optional string memoryInfo,
    10: optional string diskInfo,
    11: optional string networkCardInfo,
    12: optional string manageIp,
    13: optional string gatewayIp,
    14: optional string storeIp,
    15: optional string rackNo,
    16: optional string slotNo,
    17: i64 accountId
}
struct ListServerNodesResponse_Thrift {
    1: i64 responseId
    2: i32 recordsTotal,
    3: i32 recordsAfterFilter,
    4: list<ServerNode_Thrift> serverNodesList
}

struct ListServerNodeByIdRequest_Thrift {
    1: i64 requestId,
    2: string serverId
}
struct ListServerNodeByIdResponse_Thrift {
    1: i64 responseId,
    2: ServerNode_Thrift serverNode
}

struct GetDiskSmartInfoRequest_Thrift {
    1: i64 requestId,
    2: string serverId,
    3: string diskName,
}

struct GetDiskSmartInfoResponse_Thrift {
    1: i64 requestId,
    2: list<DiskSmartInfo_Thrift> smartInfo
}

struct UpdateDiskLightStatusByIdRequest_Thrift {
    1: i64 requestId,
    2: string diskId,
    3: string status
}
struct UpdateDiskLightStatusByIdResponse_Thrift {
    1: i64 responseId
}

struct TurnOffAllDiskLightByServerIdRequest_Thrift {
    1: i64 requestId,
    2: string serverId
}

struct TurnOffAllDiskLightByServerIdResponse_Thrift {
    1: i64 responseId,
}

struct ChangeDiskLightStatusRequest {
    1: i64 requestId,
    2: string serverId,
    3: string networkCardInfo,
    4: string diskName,
    5: string diskLightStatus,
    6: i64 accountId
}
struct ChangeDiskLightStatusResponse {
    1: i64 responseId
}

struct GetIOLimitationRequest_Thrift {
    1: i64 requestId,
    2: i64 driverContainerId,
}
struct GetIOLimitationResponse_Thrift {
    1: i64 requestId,
    2: i64 driverContainerId,
    3: map<DriverKey_Thrift, list<IOLimitation_Thrift>> mapDriver2ItsIOLimitations,
}

struct GetIOLimitationByDriverRequest_Thrift {
    1: i64 requestId,
    2: DriverKey_Thrift driverKey_Thrift,
}
struct GetIOLimitationByDriverResponse_Thrift {
    1: i64 requestId,
    2: list<IOLimitation_Thrift> ioLimitationsList,
}

struct CopyVolumeToExistVolumeRequest_Thrift {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 oriVolumeId,
    4: i32 snapshotId,
    5: i64 destVolumeId
}
struct CopyVolumeToExistVolumeResponse_Thrift {
    1: i64 requestId
}

enum WeekDay_thrift {
    SUN=0,
    MON=1,
    TUE=2,
    WED=3,
    THU=4,
    FRI=5,
    SAT=6,
}

struct AbsoluteTime_thrift {
    1: i64 id,
    2: i64 beginTime,
    3: i64 endTime,
    4: set<WeekDay_thrift> weekDay,
}

struct RelativeTime_thrift {
    1: i64 waitTime,
}

struct RebalanceRule_thrift {
    1: i64 ruleId,
    2: string ruleName,
    3: list<AbsoluteTime_thrift> absoluteTimeList,          //can set (0-n) absolute time
    4: RelativeTime_thrift relativeTime,                    //can set up at most one relative time, and waitTime must >= 1min
}

struct AddRebalanceRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: RebalanceRule_thrift rule,
}

struct UpdateRebalanceRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: RebalanceRule_thrift rule,
}

struct ApplyRebalanceRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: RebalanceRule_thrift rule,
    4: list<i64> storagePoolIdList,
}

struct UnApplyRebalanceRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: RebalanceRule_thrift rule,
    4: list<i64> storagePoolIdList,
}

struct GetRebalanceRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<i64> ruleIdList,
}
struct GetRebalanceRuleResponse {
    1: i64 requestId,
    2: list<RebalanceRule_thrift> rules,
}
struct GetAppliedRebalanceRulePoolRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: i64 ruleId,
}
struct GetAppliedRebalanceRulePoolResponse {
    1: i64 requestId,
    2: list<StoragePool_Thrift> StoragePoolList;
}
struct GetUnAppliedRebalanceRulePoolRequest {
    1: i64 requestId,
    2: i64 accountId,
}
struct GetUnAppliedRebalanceRulePoolResponse {
    1: i64 requestId,
    2: list<StoragePool_Thrift> StoragePoolList;
}
struct DeleteRebalanceRuleRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: list<i64> ruleIdList,
}
struct DeleteRebalanceRuleResponse {
    1: i64 requestId,
    2: list<RebalanceRule_thrift> failedRuleIdList,
}

//******just for test begin *****//
struct CleanOperationInfoRequest {
    1: i64 requestId,
}
struct CleanOperationInfoResponse {
    1: i64 requestId,
}

struct InstanceIncludeVolumeInfoRequest {
    1: i64 requestId,
}
struct InstanceIncludeVolumeInfoResponse {
    1: i64 requestId,
    2: map<i64, set<i64>> instanceIncludeVolumeInfo
}

struct EquilibriumVolumeRequest {
    1: i64 requestId,
    2: bool status
}
struct EquilibriumVolumeResponse {
    1: i64 requestId,
}

//******just for test  end *****//

// All general exceptions
exception GenericException_Thrift {
  1: bool isClientIssue,
  2: string reason
}

exception TransportException_Thrift {
  1: string detail
}

// Client side issues
exception InvalidParameterValueException_Thrift {
  1: optional byte errorCode,
  2: optional string detail 
}

exception ChecksumMismatchedException_Thrift {
  1: optional string detail
}

exception StaleMembershipException_Thrift {
  1: SegmentMembership_Thrift latestMembership,
  2: optional string detail
}

exception InvalidMembershipException_Thrift {
  1: SegmentMembership_Thrift latestMembership,
  2: optional string detail
}

exception ReceiverStaleMembershipException_Thrift {
  1: optional string detail
}

exception SnapshotVersionMismatchException_Thrift {
  1: binary mySnapshotManagerInBinary,
  2: optional string detail
}

exception VolumeSizeNotMultipleOfSegmentSize_Thrift {
  1: i64 segmentSize,
  2: optional string detail
}

exception VolumeSizeIllegalException_Thrift {
  1: optional string detail
}

exception LeaseExpiredException_Thrift {
  1: optional string detail
}

exception PrimaryExistsException_Thrift {
  1: SegmentMembership_Thrift membership,
  2: optional string detail
}

exception NotPrimaryException_Thrift {
  1: SegmentMembership_Thrift membership,
  2: optional SegmentUnitStatus_Thrift myStatus,
  3: optional string detail
}

exception NotSecondaryException_Thrift {
  1: SegmentMembership_Thrift membership,
  2: optional SegmentUnitStatus_Thrift myStatus,
  3: optional string detail
}

exception YouAreNotInMembershipException_Thrift {
  1: SegmentMembership_Thrift membership,
  2: optional string detail
}

exception YouAreNotInRightPositionException_Thrift {
  1: SegmentMembership_Thrift membership,
  2: optional string detail
}

exception YouAreNotReadyException_Thrift {
  1: i64 logId,
  2: optional string detail
}

exception LogIdTooSmallException_Thrift {
  1: i64 latestLogId,
  2: SegmentMembership_Thrift membership,
  3: optional string detail
}

exception NotEnoughSpaceException_Thrift {
  1: optional string detail
}

exception NotEnoughGroupException_Thrift {
    1: i32 minGroupsNumber,
    2: optional string detail
}
exception NotEnoughNormalGroupException_Thrift {
    1: i32 minGroupsNumber,
    2: optional string detail
}

exception MemberShipChangedException_Thrift {
  1: optional string detail
}

exception SegmentExistingException_Thrift {
  1: optional string detail
}

exception SegmentOfflinedException_Thrift {
  1: optional string detail
}

exception SegmentUnitBeingDeletedException_Thrift {
  1: optional string detail
}

exception NoMemberException_Thrift {
  1: optional string detail
}

exception VolumeNotFoundException_Thrift {
  1: optional string detail
}

exception VolumeUnderOperationException_Thrift {
  1: optional string detail
}

exception SnapshotDeletingException_Thrift {
  1: optional string detail
}

exception SnapshotCreatingException_Thrift {
  1: optional string detail
}

exception SnapshotRollingBackException_Thrift {
  1: optional string detail
}

exception DriverLaunchingException_Thrift {
  1: optional string detail
}

exception DriverUnmountingException_Thrift {
  1: optional string detail
}

exception VolumeDeletingException_Thrift {
  1: optional string detail
}

exception VolumeCyclingException_Thrift {
  1: optional string detail
}

exception VolumeMarkReadWriteException_Thrift {
  1: optional string detail
}

exception VolumeExtendException_Thrift {
  1: optional string detail
}

exception VolumeInMoveException_Thrift {
  1: optional string detail
}

exception VolumeInMoveOnlineException_Thrift {
  1: optional string detail
}

exception VolumeInCopyException_Thrift {
  1: optional string detail
}

exception VolumeInCloneException_Thrift {
  1: optional string detail
}

exception VolumeInUpdateActionException_Thrift {
  1: optional string detail
}

exception VolumeInReportException_Thrift {
  1: optional string detail
}

exception SnapshotBeMountedException_Thrift {
  1: optional string detail
}

exception CoordinatorSyncException_Thrift {
  1: optional string detail
}

exception NotRootVolumeException_Thrift {
  1: optional string detail
}

exception ServiceHavingBeenShutdown_Thrift {
  1: optional string detail
}

exception ResourceExhaustedException_Thrift{
  1: optional string detail
}

exception OperationNotFoundException_Thrift {
    1: optional string detail
}

exception DriverFromRequestNotFoundException_Thrift {
    1: optional string detail
}

exception VolumeInMoveOnlineDoNotHaveOperationException_Thrift {
    1: optional string detail
}

exception SnapshotIsInCloningException_Thrift{
    1: optional string detail
}

exception ChangeDiskLightStatusTimeoutException_Thrift {
    1: optional string detail
}

/* when the service has an unknown internal error. 
 * TException is supposed to be used, but the client throws IOException when the service returns TException.
 * Therefore, we explicitly define this exception.
 */ 
exception InternalError_Thrift {
  1: optional string detail
}

exception VolumeNotAvailableException_Thrift {
  1: optional string detail
}

/**
 * When launch driver with specified amount which is lagger than amount of existing available driver containers,
 * drivers cannot be launched because lack of driver containers, exception {@link TooManyDriversException_Thrift}
 * should be thrown out.
 */
exception TooManyDriversException_Thrift {
  1: optional string detail
}

exception NoDriverLaunchException_Thrift {
  1: optional string detail
}

exception InvalidInputException_Thrift {
  1: optional string detail
}

exception VolumeExistingException_Thrift {
  1: optional string detail
}

exception AccessDeniedException_Thrift {
  1: optional string detail
}

exception OlderPasswordIncorrectException_Thrift {
    1: optional string detail
}

exception InsufficientPrivilegeException_Thrift {
    1: optional string detail
}

exception VolumeWasLaunchingException_Thrift {
  1: optional string detail
}

exception VolumeWasRollbackingException_Thrift {
  1: optional string detail
}

exception VolumeWasCloneingException_Thrift {
  1: optional string detail
}

exception StorageEmptyException_Thrift {
  1: optional string detail
}

/** 
 * This exception throws when send a launching driver request to
 * launch driver over volume which is already binding a driver
 * before or delete volume still binding a driver. In a word, when
 * process some operation with no existing driver, but the driver existing
 * 
 */
exception ExistsDriverException_Thrift {
  1: optional string detail
}

/**
 * When request to umount driver and exists some client using the driver, throws this exception
 * to refuse the request. Of course other operation depends on no clients would be refused if
 * there are some clients by throw this exception.
 */ 
exception ExistsClientException_Thrift {
  1: optional string detail
}

/**
 * When request to launch driver with driver type different from 
 * driver type of existing drivers, throw this exception to refuse
 * the request because the case is not allowed in system.
 */
exception DriverTypeConflictException_Thrift {
  1: optional string detail
}

/**
 *system memory is not enough for doing something
 */
exception SystemMemoryIsNotEnough_Thrift {
  1: optional string detail
}

/**
 *system cpu is not enough for doing something
 */
exception SystemCpuIsNotEnough_Thrift {
  1: optional string detail
}

/**
 *set driver host error
 */
exception DriverAmountAndHostNotFit_Thrift{
 1: optional string detail
}

exception DriverHostCannotUse_Thrift{
 1: optional string detail
}

/**
 * When request to umount driver which is still launching, refuse the request
 * by throwing this exception.
 */
exception DriverIsLaunchingException_Thrift {
  1: optional string detail
}

exception DriverLaunchFailedException_Thrift {
  1: optional string detail
}

exception UnknownIPV4HostException_Thrift {
  1: optional string detail
}

exception UnknownIPV6HostException_Thrift {
  1: optional string detail
}

exception DriverIsUpgradingException_Thrift {
  1: optional string detail
}

exception ChangeDriverBoundVolumeFailed_Thrift {
  1: optional string detail
}

/**
* The exception throws when driverType from launchRequest conflict with exist driverType in driverStore.
* At a volume ,iscsi type driver with pyd type driver (iscsi with iscsi ,pyd with pyd) is conflict.
**/
exception DriverTypeIsConflictException_Thrift {
  1: optional string detail
}

exception DriverNameExistsException_Thrift {
  1: optional string detail
}


exception DriverContainerIsINCException_Thrift {
  1: optional string detail
}

exception FailedToUmountDriverException_Thrift {
  1: optional string detail,
}

exception InstanceNotExistsException_Thrift {
  1: optional string detail
}

exception InstanceHasFailedAleadyException_Thrift {
  1: optional string detail
}

exception ExceedUserMaxCapacityException_Thrift {
  1: i64 userMaxCapacityBytes,
  2: optional string detail
}

exception VolumeHasNotBeenLaunchedException_Thrift {
  1: optional string detail
}

exception VolumeLaunchMultiDriversException_Thrift {
  1: optional string detail
}

exception ReadPerformanceParameterFromFileException_Thrift {
  1: optional string detail
}

exception VolumeBeingDeletedException_Thrift {
  1: optional string detail
}

exception RootVolumeBeingDeletedException_Thrift {
  1: optional string detail
}

exception RootVolumeNotFoundException_Thrift {
  1: optional string detail
}

exception VolumeNameExistedException_Thrift {
  1: optional string detail
}

exception VolumeAccessRuleDuplicate_Thrift {
  1: optional string detail
}

exception VolumeInExtendingException_Thrift {
  1: optional string detail
}

exception InvalidGroupException_Thrift {
  1: optional string detail
}

exception DomainExistedException_Thrift {
  1: optional string detail
}

exception DomainNameExistedException_Thrift {
  1: optional string detail
}

exception DomainNotExistedException_Thrift {
  1: optional string detail
}

exception DomainIsDeletingException_Thrift {
  1: optional string detail
}

exception InstanceIsSubHealthException_Thrift {
   1:optional list<InstanceMetadata_Thrift> instanceMetadata,
   2: optional string detail
}
exception DatanodeNotFreeToUseException_Thrift {
  1: optional string detail
}

exception DatanodeNotFoundException_Thrift {
  1: optional string detail
}

exception DatanodeTypeNotSetException_Thrift {
  1: optional string detail
}

exception StillHaveStoragePoolException_Thrift {
  1: optional string detail
}

exception FailToRemoveDatanodeFromDomainException_Thrift {
  1: optional string detail
}

exception StoragePoolExistedException_Thrift {
  1: optional string detail
}

exception StoragePoolNameExistedException_Thrift {
  1: optional string detail
}

exception StoragePoolNotExistedException_Thrift {
  1: optional string detail
}

exception StoragePoolIsDeletingException_Thrift {
  1: optional string detail
}

exception ArchiveNotFreeToUseException_Thrift {
  1: optional string detail
}

exception ArchiveNotFoundException_Thrift {
  1: optional string detail
}

exception StillHaveVolumeException_Thrift {
  1: optional string detail
}

exception FailToRemoveArchiveFromStoragePoolException_Thrift {
  1: optional string detail
}

exception DatanodeIsUsingException_Thrift {
  1: optional string detail
}

exception LackDatanodeException_Thrift{
    1:optional string detail,
    2:i64   instanceId
}

exception FrequentFixVolumeRequest_Thrift{
    1:optional string detail,
}

exception ArchiveIsUsingException_Thrift {
  1: optional string detail
}

exception StoragePoolNotExistInDoaminException_Thrift {
  1: optional string detail
}

exception LaunchedVolumeCannotBeDeletedException_Thrift {
  1: optional string detail,
  2: bool isDriverUnknown
}

exception LaunchedVolumeCannotRollbackException_Thrift {
  1: optional string detail
}

exception VolumeCannotBeRecycledException_Thrift {
  1: optional string detail
}

exception SnapshotCountReachMaxException_Thrift {
  1: optional string detail
}

exception SnapshotNameExistException_Thrift {
  1: optional string detail
}

exception SnapshotExistException_Thrift {
  1: optional string detail
}

exception SnapshotSaveToDBException_Thrift {
  1: optional string detail
}

exception SnapshotNotFoundException_Thrift {
  1: optional string detail
}

exception SnapshotNameTooLongException_Thrift {
  1: optional string detail
}

exception SnapshotDescriptionTooLongException_Thrift {
  1: optional string detail
}

exception VolumeIsCloningException_Thrift {
  1: optional string detail
}

exception OriVolumeCanNotFoundException_Thrift {
  1: optional string detail
}

exception DestVolumeCanNotFoundException_Thrift {
  1: optional string detail
}

exception OriVolumeNotAvailableException_Thrift {
  1: optional string detail
}

exception DestVolumeNotAvailableException_Thrift {
  1: optional string detail
}

exception DestVolumeSmallerThanOriVolumeException_Thrift {
  1: optional string detail
}

exception DestVolumeIsCopyingException_Thrift {
  1: optional string detail
}

exception ServerNodeIsUnknown_Thrift {
    1: optional string detail
}

exception ServerNodeNotExistException_Thrift {
    1: optional string detail
}

exception DiskSizeCanNotSupportArchiveTypes_thrift {
        1: optional string detail
}

exception DiskNameIllegalException_Thrift {
    1: optional string detail
}

/**    exception for move volume **/
exception VolumeIsBeginMovedException_Thrift {
  1: optional string detail
}

exception VolumeIsMovingException_Thrift {
  1: optional string detail
}

/**    exception for scsi volume **/
exception ScsiClientIsExistException_Thrift {
  1: optional string detail
}

exception ScsiClientIsNotOkException_Thrift {
  1: optional string detail
}

exception ScsiVolumeLockException_Thrift {
  1: optional string detail
}

/*
 * dynamic set parameters
 */
struct ConfigServiceRequest_Thrift {
    1: i64 requestId,
    2: map<string, string> configuration
}

struct ConfigServiceResponse_Thrift {
    1: i64 requestId,
    2: map<string, string> invalidConfiguration
}

struct ViewServiceConfigurationRequest_Thrift {
    1: i64 requestId
}

struct ViewServiceConfigurationResponse_Thrift {
    1: i64 requestId,
    2: map<string, string> configuration
}

//********** license begin ***********/

struct GenericLicenseSequenceNumberRequest_Thrift {
    1:i64 requestId,
    2:i64 accountId,
    3:string userName;
}

struct GenericLicenseSequenceNumberResponse_Thrift {
    1:i64 requestId,
    2:string sequenceNumber
}

struct InstallLicenseRequest_Thrift{
    1:i64 requestId,
    2:i64 accountId,
    3:string userName,
    4:string license;
}

struct InstallLicenseResponse_Thrift{
    1:i64 requestId
}

struct UpdateLicenseRequest_Thrift{
    1:i64 requestId,
    2:i64 accountId,
    3:string userName,
    4:string license;
}

struct UpdateLicenseResponse_Thrift{
    1:i64 requestId
}

struct ViewLicenseRequest_Thrift{
    1: i64 requestId,
    2: i64 accountId,
    3: string userName;
}

struct ViewLicenseResponse_Thrift{
    1: i64 requestId,
    2: string type,
    3: string sequenceNumber,
    4: string startTime,
    5: map<string, string> resourceTokens,
    6: map<string, string> functionTokens,
    7: i64 internalTime,
    8: i64 licenseAge
}

struct UninstallLicenseRequest_Thrift{
    1:i64 requestId,
    2:i64 accountId,
    3:string userName;
}

struct UninstallLicenseResponse_Thrift{
    1:i64 requestId
}

struct HeartbeatDisableRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i32 segIndex
}

struct HeartbeatDisableResponse {
   1: i64 requestId
}


struct WriteMutationLogsDisableRequest {
   1: i64 requestId,
   2: i64 volumeId,
   3: i32 segIndex
}

struct RemoveUncommittedLogsExceptForThoseGivenRequest {
   1: i64 requestId,
   2: SegId_Thrift segId,
   3: list<i64> givenLogIds
}

struct RemoveUncommittedLogsExceptForThoseGivenResponse {
   1: i64 requestId,
   2: SegId_Thrift segId,
   3: list<i64> deletedLogIds
}

struct WriteMutationLogsDisableResponse {
   1: i64 requestId
}

/* check driver connect permission begin */
struct GetDriverConnectPermissionRequest_Thrift {
   1: i64 requestId,
   2: i64 driverContainerId,
   3: i64 volumeId,
   4: i32 snapshotId,
   5: DriverType_Thrift driverType;
}

struct GetDriverConnectPermissionResponse_Thrift {
   1: i64 requestId,
   2: map<string, AccessPermissionType_Thrift> connectPermissionMap;
}
/* check driver connect permission end */

/* iscsi chap control begin */
struct SetIscsiChapControlRequest_Thrift {
   1: i64 requestId,
   /* use driverkey */
   2: i64 driverContainerId,
   3: i64 volumeId,
   4: i32 snapshotId,
   5: DriverType_Thrift driverType,
   /* 0:disable  1:enable */
   6: i32 chapControl;
}

struct SetIscsiChapControlResponse_Thrift {
   1: i64 requestId;
}
/* iscsi chap control end */

struct ShowIORequest_Thrift {
   1:i64 requestId,
}

struct IOInformation_Thrift {
   1:i64 oriId,
   2:i32 sendCount,
   3:i32 responseCount,
   4:i64 spendTime,
   5:i32 sendTimes;
}

struct PageMigrationSpeedInfo_Thrift {
   1: i64 maxMigrationSpeed
}

struct ShowIOResponse_Thrift {
   1:i64 requestId,
   2:list<IOInformation_Thrift> readNotResponseList,
   3:list<IOInformation_Thrift> writeNotResponseList;
}

// account manager begin
enum AccountType_Thrift {
   SuperAdmin = 1,
   Admin = 2,
   Regular = 3
}

struct APIToAuthorize_Thrift {
    1:string apiName,
    2:string category,
    3:string chineseText,
    4:string englishText;
}

struct Role_Thrift {
    1: i64 id,
    2: string name,
    3: string description,
    4: set<APIToAuthorize_Thrift> permissions,
    5: bool builtIn,
    6: bool superAdmin;
}

struct Resource_Thrift {
    1: i64 resourceId,
    2: string resourceName,
    3: string resourceType,
}

struct AccountMetadata_Thrift {
    1: i64 accountId,
    2: string accountName,
    3: AccountType_Thrift accountType,
    4: set<Role_Thrift> roles,
    5: set<Resource_Thrift> resources;
}

struct AccountMetadataBackup_Thrift {
    1: i64 accountId,
    2: string accountName,
    3: string hashedPassword,
    4: string salt,
    5: string accountType,
    6: set<Role_Thrift> roles,
    7: set<Resource_Thrift> resources,
    8: i64 createdAt;
}

struct CreateAccountRequest {
   1: string accountName,
   2: string password,
   3: AccountType_Thrift accountType,
   4: i64 accountId,
   5: optional i64 creatingAccountId,
   6: set<i64> roleIds;
}
struct CreateAccountResponse {
    1: i64 accountId,
    2: string accountName
}

struct DeleteAccountsRequest {
    1: i64 requestId,
    2: i64 accountId,
    3: set<i64> deletingAccountIds;
}
struct DeleteAccountsResponse {
    1: i64 requestId,
    2: set<i64> deletedAccountIds;
}

struct UpdatePasswordRequest {
   1:string accountName,
   2:string oldPassword,
   3:string newPassword,
   4:i64 accountId;
}
struct UpdatePasswordResponse {
   1:i64 accountId,
}

struct ListAccountsRequest {
    1: i64 accountId,
    2: optional set<i64> listAccountIds;
}
struct ListAccountsResponse {
    1: list<AccountMetadata_Thrift> accounts;
}

struct AuthenticateAccountRequest {
    1:string accountName,
    2:string password
}
struct AuthenticateAccountResponse {
    1:i64 accountId,
    2:string accountName,
    3:AccountType_Thrift accountType,
    4:list<Role_Thrift> roles,
    5:list<APIToAuthorize_Thrift> apis
}

struct GetAccountRequest {
    1:i64 requestId,
    2:i64 accountId
}
struct GetAccountResponse {
    1:i64 requestId,
    2:AccountMetadata_Thrift accountMetadata
}

struct ResetAccountPasswordRequest {
	1:i64 requestId,
	2:i64 accountId,
	3:i64 targetAccountId,
	4:AccountType_Thrift accountType
}
struct ResetAccountPasswordResponse {
	1:i64 requestId,
	2:string password
}

struct ListResourcesRequest {
	1: i64 requestId,
	2: i64 accountId,
	3: optional set<i64> listResourceIds;
}
struct ListResourcesResponse {
	1: i64 requestId,
	2: list<Resource_Thrift> resources;
}

struct AssignResourcesRequest {
	1: i64 requestId,
	2: i64 accountId,
	3: i64 targetAccountId,
	4: set<i64> resourceIds;
}
struct AssignResourcesResponse {
	1: i64 requestId;
}

//********** report DB request & reponse *******/

struct ReportDBRequest_Thrift {
   1:i64 sequenceId,
   2:i64 instanceId,
   3:string endpoint,
   4:Group_Thrift group,
   5:optional list<Domain_Thrift> domainThriftList,
   6:optional list<StoragePool_Thrift> storagePoolThriftList,
   7:optional list<VolumeRuleRelationship_Thrift> volume2RuleThriftList,
   8:optional list<VolumeAccessRule_Thrift> accessRuleThriftList,
   9:optional list<IscsiRuleRelationship_Thrift> iscsi2RuleThriftList,
   10:optional list<IscsiAccessRule_Thrift> iscsiAccessRuleThriftList,
   11:optional list<CapacityRecord_Thrift> capacityRecordThriftList,
   12:optional list<VolumeCloneRelationship_Thrift> cloneRelationshipThriftList,
   13:optional LicenseCryptogramInformation_Thrift licenseCryptogramThrift,
   14: optional list<AccountMetadataBackup_Thrift> accountMetadataBackupThriftList,
   15: optional list<Role_Thrift> roleThriftList,
   16:optional list<APIToAuthorize_Thrift> apiThriftList,
   17:optional list<Resource_Thrift> resourceThriftList,
   18:optional list<IOLimitationRelationShip_Thrift> ioLimitationRelationShipThriftList,
   19:optional list<IOLimitation_Thrift> ioLimitationThriftList,
   20:optional list<MigrationRuleRelationShip_Thrift> migrationRuleRelationShipThriftList,
   21:optional list<MigrationRule_Thrift> migrationRuleThriftList,
   22:optional list<RebalanceRule_thrift> rebalanceRuleThriftList,

}

struct ReportDBResponse_Thrift {
   1:i64 sequenceId,
   2:optional list<Domain_Thrift> domainThriftList,
   3:optional list<StoragePool_Thrift> storagePoolThriftList,
   4:optional list<VolumeRuleRelationship_Thrift> volume2RuleThriftList,
   5:optional list<VolumeAccessRule_Thrift> accessRuleThriftList,
   6:optional list<IscsiRuleRelationship_Thrift> iscsi2RuleThriftList,
   7:optional list<IscsiAccessRule_Thrift> iscsiAccessRuleThriftList,
   8:optional list<CapacityRecord_Thrift> capacityRecordThriftList,
   9:optional list<VolumeCloneRelationship_Thrift> cloneRelationshipThriftList,
   10:optional LicenseCryptogramInformation_Thrift licenseCryptogramThrift,
   11:optional list<AccountMetadataBackup_Thrift> accountMetadataBackupThriftList,
   12: optional list<Role_Thrift> roleThriftList,
   13:optional list<APIToAuthorize_Thrift> apiThriftList,
   14:optional list<Resource_Thrift> resourceThriftList;
   15:optional list<IOLimitationRelationShip_Thrift> ioLimitationRelationShipThriftList,
   16:optional list<IOLimitation_Thrift> ioLimitationThriftList,
   17:optional list<MigrationRuleRelationShip_Thrift> migrationSpeedRelationShipThriftList,
   18:optional list<MigrationRule_Thrift> migrationSpeedThriftList,
   19:optional list<RebalanceRule_thrift> rebalanceRuleThriftList,

}
//*********** End *****************************/

//********** get database info ****************/
struct GetDBInfoRequest_Thrift {
   1:i64 requestId,
}

struct GetDBInfoResponse_Thrift {
   1:i64 requestId,
   2:ReportDBRequest_Thrift dbInfo,
}
//*********** End *****************************/

//*******let Inactive Second leave start**/

struct CheckSecondaryInactiveThreshold_Thrift{
   1:CheckSecondaryInactiveThresholdMode_Thrift mode;
   2:optional i64 startTime;
   3:optional i64 endTime;
   4:optional i64 waitTime;
   5:bool ignoreMissPagesAndLogs;
}


//*******let Inactive Second leave end**/

struct ChangeIOPathRequest_Thrift {
   1:i64 requestId,
   2:i64 newVolumeId,
   3:i32 snapshotId,
}

struct ChangeIOPathResponse_Thrift {
   1:i64 requestId,
}

exception AccountNotFoundException_Thrift {
    1: optional string detail
}
exception AuthenticationFailedException_Thrift {
    1: optional string detail
}
exception RoleNotExistedException_Thrift {
    1: optional string detail
}
exception CRUDBuiltInRoleException_Thrift {
    1: optional string detail
}
exception CRUDSuperAdminAccountException_Thrift {
    1: optional string detail
}
exception ResourceNotExistsException_Thrift {
    1: optional string detail
}
exception RoleIsAssignedToAccountsException_Thrift {
    1: optional string detail
}
exception DeleteRoleException_Thrift {
    1: map<string, string> failedRoleName2Cause
}
exception DeleteLoginAccountException_Thrift {
    1: optional string detail
}

// account manager end

exception InvalidLicenseFileException_Thrift {
    1: optional string detail
}

exception LicenseExistedException_Thrift {
    1: optional string detail
}

exception NoLicenseException_Thrift{
    1: optional string detail
}

exception BadLicenseTokenException_Thrift {
    1: optional string detail
}

exception UselessLicenseException_Thrift {
    1: optional string detail
}

exception NotEnoughLicenseTokenException_Thrift {
    1: optional string detail
}

exception DiskNotFoundException_Thrift {
    1: optional string detail
}

exception ArchiveTypeNotSupportException_Thrift{
    1:optional string detail
}

exception DiskHasBeenOnline_Thrift {
    1: optional string detail
}

exception DiskHasBeenOffline_Thrift {
    1: optional string detail
}

exception DiskNotBroken_Thrift {
    1: optional string detail
}

exception DiskNotMismatchConfig_Thrift {
    1: optional string detail
}

exception DiskIsBusy_Thrift {
    1: optional string detail
}

/**
 * Service is not available when its state is suspend,inc...
 * Any request sent to this service would receive this exception.
 */ 
exception ServiceIsNotAvailable_Thrift {
    1: optional string detail
}

exception ParametersIsErrorException_Thrift {
    1:optional string detail
}


exception LimitationNotExistException_Thrift {
    1: optional string detail
}

exception LimitationAlreadyExistException_Thrift {
    1: optional string detail
}

exception AlreadyExistStaticLimitationException_Thrift {
    1: optional string detail
}

exception DynamicIOLimitationTimeInterleavingException_Thrift {
    1: optional string detail
}

exception ModificationTooLateExistException_Thrift {
    1: optional string detail
}

exception DriverNotFoundException_Thrift {
    1: optional string detail
}

exception TimeoutException_Thrift {
    1: optional string detail
}

exception LoadVolumeException_Thrift {
    1: optional string detail
}

exception ConnectionRefusedException_Thrift {
    1: optional string detail
}

exception VolumeIsMarkWriteException_Thrift {
    1: optional string detail
}

exception VolumeIsAppliedWriteAccessRuleException_Thrift {
    1: optional string detail
}

exception VolumeIsConnectedByWritePermissionClientException_Thrift {
    1: optional string detail
}

exception ApplyFailedDueToVolumeIsReadOnlyException_Thrift {
    1: optional string detail
}

exception ApplyFailedDueToConflictException_Thrift {
    1: optional string detail
}

exception PermissionNotGrantException_Thrift {
    1: optional string detail
}

exception AccountAlreadyExistsException_Thrift {
   1: optional string detail
}

exception ServerNodePositionIsRepeatException_Thrift {
    1: optional string detail
}

exception PrimaryCandidateCantBePrimaryException_Thrift {
  1: optional string deatil
}

exception SrcVolumeHaveDriverException_Thrift {
  1: optional string detail
}

exception SrcVolumeDoesNotHaveExactOneDriverException_Thrift {
  1: optional string detail
}

exception OriVolumeHasDriverWhenCopyException_Thrift {
  1: optional string detail
}

exception DestVolumeHasDriverWhenCopyException_Thrift {
  1: optional string detail
}

exception SegmentUnitCloningException_Thrift {
    1: optional string detail
}

exception ArchiveManagerNotSupportException_Thrift {
    1:ArchiveType_Thrift archiveType,
    2:optional string detail,
}

exception VolumeIsCopingException_Thrift {
  1: optional string detail
}

exception EndPointNotFoundException_Thrift {
  1: optional string detail
}

exception TooManyEndPointFoundException_Thrift {
  1: optional string detail
}

exception NetworkErrorException_Thrift {
  1: optional string detail
}

exception LicenseException_Thrift {
  1: optional string detail
}

exception UnsupportedEncodingException_Thrift {
  1: optional string detail
}

//********** end ***********/

//********** move online ***********/
exception MoveOnlineTheVolumeHasInitException_Thrift {
  1: optional string detail
}

exception BuiltInMigrationRuleNotAllowedDeletedException_Thrift{
  1: optional string detail
}

exception BuiltInMigrationRuleNotAllowedUpdatedException_Thrift{
  1: optional string detail
}

//********** end ***********/

//********** rebalance ***********/
exception PoolAlreadyAppliedRebalanceRuleException_Thrift {
  1: optional string detail,
  2: optional RebalanceRule_thrift rebalanceRule,       //already applied rule
}

exception RebalanceRuleNotExistException_Thrift {
  1: optional string detail,
}

exception RebalanceRuleExistingException_Thrift {
  1: optional string detail,
}

//********** end ***********/

//********** clone ***********/
exception CloneVolumeMustFromSnapshotException_Thrift {
  1: optional string detail,
}

exception CloneVolumeLayersTooDeepException_Thrift {
  1: optional string detail,
}
//********** end ***********/

exception UnsupportedCacheTypeException_Thrift {
  1: optional string detail,
}

exception UnsupportedWTSTypeException_Thrift {
  1: optional string detail,
}


service DebugConfigurator{
   // Set new configuration values. There is a map within the request which store the existing configuration keys and their new value
   SetConfigurationsResponse setConfigurations(1:SetConfigurationsRequest request),
   // Get new configuration values. There is an optional list within the request which store the requested existing configuration keys
   // If the optional list is null or empty then all configurations are returned
   GetConfigurationsResponse getConfigurations(1:GetConfigurationsRequest request),

}
