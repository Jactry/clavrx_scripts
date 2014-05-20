#!/bin/bash

./install_clavrx_branch.sh new_cloud_mask test
cd test
wget -r ftp://ftp.ssec.wisc.edu/pub/awalther/CLAVRX_TEST_DATA/ ./

