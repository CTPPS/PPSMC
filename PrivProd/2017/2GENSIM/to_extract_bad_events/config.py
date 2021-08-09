# Auto generated configuration file
# using: 
# Revision: 1.19 
# Source: /local/reps/CMSSW/CMSSW/Configuration/Applications/python/ConfigBuilder.py,v 
# with command line options: Configuration/GenProduction/python/PPS-RunIIFall17GS-00008-fragment.py --filein dbs:/GGToZZ_bSM-A0Z-1e-5_PtL-15_13TeV-fpmc-herwig6/RunIIFall17pLHE-93X_mc2017_realistic_v3-v1/LHE --fileout file:PPS-RunIIFall17GS-00008.root --mc --eventcontent RAWSIM --datatier GEN-SIM --conditions 93X_mc2017_realistic_v3 --beamspot Realistic25ns13TeVEarly2017Collision --step GEN,SIM --nThreads 8 --geometry DB:Extended --era Run2_2017 --python_filename PPS-RunIIFall17GS-00008_1_cfg.py --no_exec --customise Configuration/DataProcessing/Utils.addMonitoring -n 2233
import FWCore.ParameterSet.Config as cms

from Configuration.StandardSequences.Eras import eras

process = cms.Process('SIM',eras.Run2_2017)

# import of standard configurations
process.load('Configuration.StandardSequences.Services_cff')
process.load('SimGeneral.HepPDTESSource.pythiapdt_cfi')
process.load('FWCore.MessageService.MessageLogger_cfi')
process.load('Configuration.EventContent.EventContent_cff')
process.load('SimGeneral.MixingModule.mixNoPU_cfi')
process.load('Configuration.StandardSequences.GeometryRecoDB_cff')
process.load('Configuration.StandardSequences.GeometrySimDB_cff')
process.load('Configuration.StandardSequences.MagneticField_cff')
process.load('Configuration.StandardSequences.Generator_cff')
process.load('IOMC.EventVertexGenerators.VtxSmearedRealistic25ns13TeVEarly2017Collision_cfi')
process.load('GeneratorInterface.Core.genFilterSummary_cff')
process.load('Configuration.StandardSequences.SimIdeal_cff')
process.load('Configuration.StandardSequences.EndOfProcess_cff')
process.load('Configuration.StandardSequences.FrontierConditions_GlobalTag_cff')

process.maxEvents = cms.untracked.PSet(
    input = cms.untracked.int32(xevt)
)

# Input source
process.source = cms.Source("PoolSource",
    dropDescendantsOfDroppedBranches = cms.untracked.bool(False),
    fileNames = cms.untracked.vstring('file:/eos/cms/store/group/phys_pps/MC/requests_2017mcv2/private/AAZZ_bSM/pLHE/xjob/xinput'),
    firstEvent=cms.untracked.uint32(xfirst),
    inputCommands = cms.untracked.vstring('keep *', 
        'drop LHEXMLStringProduct_*_*_*'),
    secondaryFileNames = cms.untracked.vstring(),
    eventsToSkip = cms.untracked.VEventRange( *('1:30','1:85','1:189','1:460','1:823','1:849','1:1046','1:1116','1:1149','1:1170','1:1531','1:1576','1:1658','1:2135','1:2188','1:2202','1:3149','1:3331','1:3768','1:3837','1:4241','1:4314','1:4334','1:4413','1:4799','1:4910','1:5181','1:5650','1:6049','1:6060','1:6091','1:6185','1:6446','1:6601','1:6784','1:7106','1:7441','1:7997','1:8179','1:8383','1:8828','1:9648','1:9696','1:10094','1:10292','1:10348','1:10378','1:10411','1:10550','1:11354','1:11404','1:11487','1:11655','1:11720','1:11983','1:12704','1:12833','1:13105','1:13177','1:13459','1:14390','1:14976','1:14982','1:15231','1:15362','1:15983','1:16362','1:16419','1:16797','1:17047','1:17173','1:17491','1:17616','1:17783','1:17851','1:18051','1:18266','1:18424','1:18904','1:19036','1:19247','1:19306','1:19687','1:19797','1:20308','1:20354','1:20681','1:20825','1:20856','1:21207','1:21350','1:22592','1:23222','1:23532','1:23647','1:23662','1:23801','1:24124','1:24496','1:24518','1:24587','1:25105','1:25128','1:25199','1:25484','1:25596','1:25721','1:26013','1:26112','1:26223','1:26228','1:26361','1:26653','1:26802','1:27407','1:27474','1:27824','1:27895','1:28019','1:28789','1:28868','1:28948','1:29379','1:29633','1:30148','1:30384','1:30620','1:30692','1:31479','1:31518','1:31658','1:32042','1:32109','1:32173','1:32315','1:32447','1:32490','1:32541','1:32592','1:32701','1:32750','1:32772','1:32865','1:32913','1:33001','1:33311','1:33329','1:33435','1:33594','1:33766','1:33968','1:34007','1:34194','1:34523','1:34627','1:34857','1:34871','1:35046','1:35356','1:35505','1:35640','1:35746','1:35879','1:35884','1:35938','1:36162','1:36414','1:36522','1:36885','1:37174','1:37260','1:37275','1:37441','1:37482','1:37717','1:37813','1:37951','1:38199','1:38487','1:38539','1:38662','1:38780','1:38892','1:38945','1:38986','1:39127','1:39138','1:39442','1:39500','1:39617','1:40122','1:40320','1:40436','1:40911','1:41322','1:41506','1:41690','1:41928','1:42519','1:42706','1:42856','1:42952','1:43035','1:43110','1:43901','1:44028','1:44112','1:44199','1:44200','1:45191','1:45280','1:46281','1:46772','1:46990','1:47348','1:47861','1:48093','1:48139','1:48415','1:48482','1:49148','1:49193','1:49530','1:49562','1:49722','1:49778','1:50056','1:50835','1:51071','1:51207','1:51389','1:51551','1:52130','1:52248','1:52392','1:52804','1:52867','1:52942','1:53094','1:53289','1:53450','1:53475','1:53832','1:53874','1:54106','1:54288','1:54399','1:54458','1:54484','1:54583','1:54874','1:54917','1:55364','1:55384','1:55567','1:55651','1:55903','1:55963','1:56335','1:56471','1:56730','1:57383','1:57442','1:57754','1:58155','1:58353','1:58360','1:58873','1:58938','1:58943','1:59150','1:59351','1:59389','1:60163','1:60771','1:61004','1:61245','1:61795','1:61811','1:62057','1:62298','1:62860','1:63272','1:63375','1:64375','1:64615','1:65044','1:65247','1:65359','1:65790','1:66660','1:66935','1:67182','1:67194','1:67511','1:67864','1:68100','1:68363','1:68704','1:69280','1:69287','1:70460','1:70966','1:70978','1:71667','1:71672','1:71873','1:71938','1:72207','1:72697','1:72878','1:72889','1:73184','1:73794','1:73809','1:74039','1:74130','1:74145','1:75333','1:75610','1:75686','1:75881','1:76021','1:76627','1:76697','1:76749','1:77044','1:77074','1:77656','1:77770','1:77789','1:77998','1:78055','1:78256','1:78357','1:78384','1:78645','1:78963','1:79096','1:79258','1:79403','1:79587','1:80216','1:80314','1:80512','1:80947','1:81335','1:81355','1:81706','1:81887','1:82120','1:82586','1:84477','1:85105','1:85215','1:85896','1:86547','1:86651','1:87002','1:87405','1:87456','1:87542','1:87670','1:87872','1:88056','1:88476','1:88486','1:88636','1:88751','1:88797','1:88879','1:88934','1:89022','1:89149','1:89356','1:89366','1:89373','1:89429','1:89452','1:89506','1:90050','1:90138','1:90259','1:90947','1:90970','1:91312','1:91727','1:92420','1:92442','1:92457','1:92534','1:92819','1:92845','1:92858','1:93047','1:93512','1:93967','1:94033','1:94110','1:94392','1:94393','1:94514','1:94943','1:95857','1:95970','1:96044','1:96119','1:96559','1:96714','1:96899','1:97189','1:98086','1:98547','1:99098') ),
)

## FOR AAWW PRODUCTION
#    eventsToSkip = cms.untracked.VEventRange('1:38142','1:41186','1:67678','1:70236','1:81816','1:97702')

process.options = cms.untracked.PSet(
#    SkipEvent = cms.untracked.vstring('StdException')
)

# Production Info
process.configurationMetadata = cms.untracked.PSet(
    annotation = cms.untracked.string('Configuration/GenProduction/python/PPS-RunIIFall17GS-00008-fragment.py nevts:2233'),
    name = cms.untracked.string('Applications'),
    version = cms.untracked.string('$Revision: 1.19 $')
)

# Output definition

process.RAWSIMoutput = cms.OutputModule("PoolOutputModule",
    SelectEvents = cms.untracked.PSet(
        SelectEvents = cms.vstring('generation_step')
    ),
    compressionAlgorithm = cms.untracked.string('LZMA'),
    compressionLevel = cms.untracked.int32(9),
    dataset = cms.untracked.PSet(
        dataTier = cms.untracked.string('GEN-SIM'),
        filterName = cms.untracked.string('')
    ),
    eventAutoFlushCompressedSize = cms.untracked.int32(20971520),
    fileName = cms.untracked.string('file:xfileout'),
    outputCommands = process.RAWSIMEventContent.outputCommands,
    splitLevel = cms.untracked.int32(0)
)

# Additional output definition

# Other statements
process.XMLFromDBSource.label = cms.string("Extended")
process.genstepfilter.triggerConditions=cms.vstring("generation_step")
from Configuration.AlCa.GlobalTag import GlobalTag
process.GlobalTag = GlobalTag(process.GlobalTag, '93X_mc2017_realistic_v3', '')

process.generator = cms.EDFilter("Pythia8HadronizerFilter",
    PythiaParameters = cms.PSet(
        parameterSets = cms.vstring('skip_hadronization'),
        skip_hadronization = cms.vstring(
            'ProcessLevel:all = off',
            'Check:event = off',
#            'HadronLevel:all = off'
        )
    ),
    comEnergy = cms.double(13000.0),
    filterEfficiency = cms.untracked.double(1.0),
    maxEventsToPrint = cms.untracked.int32(0),
    pythiaHepMCVerbosity = cms.untracked.bool(False),
    pythiaPylistVerbosity = cms.untracked.int32(1)
)

# Path and EndPath definitions
process.generation_step = cms.Path(process.pgen)
process.simulation_step = cms.Path(process.psim)
process.genfiltersummary_step = cms.EndPath(process.genFilterSummary)
process.endjob_step = cms.EndPath(process.endOfProcess)
process.RAWSIMoutput_step = cms.EndPath(process.RAWSIMoutput)

# Schedule definition
process.schedule = cms.Schedule(process.generation_step,process.genfiltersummary_step,process.simulation_step,process.endjob_step,process.RAWSIMoutput_step)
from PhysicsTools.PatAlgos.tools.helpers import associatePatAlgosToolsTask
associatePatAlgosToolsTask(process)

#Setup FWK for multithreaded
process.options.numberOfThreads=cms.untracked.uint32(8)
process.options.numberOfStreams=cms.untracked.uint32(0)
# filter all path with the production filter sequence
for path in process.paths:
	getattr(process,path)._seq = process.generator * getattr(process,path)._seq 

# customisation of the process.

# Automatic addition of the customisation function from Configuration.DataProcessing.Utils
from Configuration.DataProcessing.Utils import addMonitoring 

#call to customisation function addMonitoring imported from Configuration.DataProcessing.Utils
process = addMonitoring(process)

# End of customisation functions

# Customisation from command line

# Add early deletion of temporary data products to reduce peak memory need
from Configuration.StandardSequences.earlyDeleteSettings_cff import customiseEarlyDelete
process = customiseEarlyDelete(process)
# End adding early deletion
