# Private Production
The folder PrivSim contains the machinery needed to produce simulated private samples for Summer16, Fall17, and Autmn18 scenarios. For all years, the set of files consist of:

- `config.py`: CMSSW configuration file;
- `generate*.sh`: Bash macro to split the production in a certain numbers of jobs;
- `script.sh`: Bash macro for LXBATCH job run;
- `condor.sub`: HTCondor script to submit jobs.

The generate script has 3 user input parameters:
- `farea`: area where the input file is located and area that will be used to generate all simulated files;
- `nevt`: number of events to be processed;
- `nfiles`: number of files to be generated.

plus

- `gridcert`: user GRID VOMS certificate needed at DRPRemix step to read Premix libraries stored in a T2

The command line directive is:

`./generate\* [tag] [job_name]`
(`./generate-GS.sh FPMC_WW_bSM_13tev_a0w_0_aCw_8e-6_lept_pt0 GS17_WW_0_8_lept`)

where [job_name] is the HTCondor job label and [tag] defines the folder names for the output files and the tag to be used in the next steps for automate job submission. Note that [tag] has to match the filename of the input file, which has to be placed at [farea].

## **Instructions**:

- By default, all input/output files are set to a EOS area. Change the paths accordingly to your needs.

- The label set in the [tag] argument is used to create the local work directories and as filename for all output files.

- All generate macros have the line `exit 1` commented, which produced the set of files needed for the simulation and submit jobs. Uncomment that line to avoid submitting the jobs.

- The DRPremix step requires a GRID certificate to be placed at `~/private` with permission 0600.

- There are known issues at reading files from the GRID network, namely `FallbackFileOpenError` and `FileReadError` which prevents some jobs to be finished. The script `jobChecker.sh` may be used to check missing files and the aforementioned errors. The script works like inside one of the simulation step folders:

`./jobChecker.sh [work dir]`

where `[work dir]` is the directory containing the error logs and has the name as set in the `[tag]` argument.

- MINIAOD step is provided for 2017 only; if needed for other years please contact the coordinator.
