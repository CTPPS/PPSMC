# Private Production
The folder PrivProd contains the machinery needed to produce simulated private samples for Summer16, Fall17, and Autmn18 scenarios. For all years, the set of files consist of:

- `config.py`: CMSSW configuration file;
- `submitter*`: Bash macro to split the production in a certain numbers of jobs;
- `script.sh`: Bash macro for LXBATCH job run;
- `condor.sub`: HTCondor script to submit jobs.

The command line directive is:

`./submitter\* [tag] [job_name]`
(`./submitter_pLHEtoGENSIM.sh FPMC_WW_bSM_13tev_a0w_0_aCw_8e-6_lept_pt0 GS17_WW_0_8_lept`)

where [tag] defines the folder names for the output files and the tag to be used in the next steps for automate job submission and [job_name] the HTCondor job label.

## **Instructions**:

- By default, all input/output files are set to the PPS EOS area. Change the paths accordingly to your needs.

- All submitter macros have the line `exit 1` uncommented, which produced the set of files needed for the simulation, but avoid submitting jobs. Comment that line to submit the jobs.

- The DRPremix step requires a GRID certificate to be placed at `~/private` with permission 774.

- Be aware that the template for the DRPremix config file has 27MB, which will be duplicated to the number of jobs required by the user. In the case of 100 jobs, the DRPremix setup will expand to almost 3GB of disk space.

- MINIAOD step is provided for 2017 only; if needed for other years please contact the coordinator.

- Given a past experience with FPMC, a certain number of unknown problematic events had to be removed in the GENSIM step. The corresponding scripts are placed at the folder named `to_extract_bad_events`. Use these files only if specific events have to be removed from the simulation.
