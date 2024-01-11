version=5.5
wget https://github.com/darold/pgFormatter/archive/refs/tags/v${version}.tar.gz
tar xzf v${version}.tar.gz
cd pgFormatter-${version}/
perl Makefile.PL
make && sudo make install
cd ../ && rm -rf v${version}.tar.gz && rm -rf pgFormatter-${version}
