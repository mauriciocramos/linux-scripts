source "$HOME"/miniconda3/etc/profile.d/conda.sh

conda create -c conda-forge -y -n test scikit-learn-intelex
conda list -n test > conda-forge.txt

conda create -c conda-forge -y -n test blas=*=openblas scikit-learn-intelex
conda list -n test > conda-forge-blas-openblas.txt

conda create -c conda-forge -y -n test blas=*=mkl scikit-learn-intelex
conda list -n test > conda-forge-blas-mkl.txt

conda create -c intel -c conda-forge -y -n test scikit-learn-intelex
conda list -n test > intel.txt

conda create -c intel -c conda-forge -y -n test blas=*=openblas scikit-learn-intelex
conda list -n test > intel-blas-openblas.txt

conda create -c intel -c conda-forge -y -n test blas=*=mkl scikit-learn-intelex
conda list -n test > intel-blas-mkl.txt

conda env remove --name test

egrep -h -i "mutex|blas|mkl|lapack|threadpool|llvm|openmp|scikit-learn|_rt|-rt" conda-forge.txt > conda-forge.lst
mv conda-forge.lst conda-forge.txt

egrep -h -i "mutex|blas|mkl|lapack|threadpool|llvm|openmp|scikit-learn|_rt|-rt" conda-forge-blas-openblas.txt > conda-forge-blas-openblas.lst
mv conda-forge-blas-openblas.lst conda-forge-blas-openblas.txt

egrep -h -i "mutex|blas|mkl|lapack|threadpool|llvm|openmp|scikit-learn|_rt|-rt" conda-forge-blas-mkl.txt > conda-forge-blas-mkl.lst
mv conda-forge-blas-mkl.lst conda-forge-blas-mkl.txt

egrep -h -i "mutex|blas|mkl|lapack|threadpool|llvm|openmp|scikit-learn|_rt|-rt" intel.txt > intel.lst
mv intel.lst intel.txt

egrep -h -i "mutex|blas|mkl|lapack|threadpool|llvm|openmp|scikit-learn|_rt|-rt" intel-blas-openblas.txt > intel-blas-openblas.lst
mv intel-blas-openblas.lst intel-blas-openblas.txt

egrep -h -i "mutex|blas|mkl|lapack|threadpool|llvm|openmp|scikit-learn|_rt|-rt" intel-blas-mkl.txt > intel-blas-mkl.lst
mv intel-blas-mkl.lst intel-blas-mkl.txt

