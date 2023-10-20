[![img](https://img.shields.io/badge/Lifecycle-Experimental-339999)](https://github.com/bcgov/repomountie/blob/master/doc/lifecycle-badges.md)

# simsbc

*simsbc* provides access to biodiversity data and survey information
from British Columbia’s [Species Inventory Management System
(SIMS)](https://sims.nrs.gov.bc.ca).

SIMS is a web application for managing, sharing, and accessing fish and
wildlife data in British Columbia. It is designed for biologists working
for or in partnership with the Province.

The *simsbc* R package complements the web application by loading SIMS
data directly into R, removing the need to download and share data using
intermediate files. The package also makes it easy to build R Shiny
applications involving data from SIMS.

### Installation

You can install *simsbc* from GitHub using the
[remotes](https://cran.r-project.org/package=remotes) package.

``` r
install.packages("remotes")

remotes::install_github("bcgov/simsbc")

library(simsbc)
```

### Usage

- [Get data](https://bcgov.github.io/simsbc/articles/get_data.html)

### Roadmap

We are building rapidly towards letting biologists import species
observations to SIMS, after which we will build functions for retrieving
species observations.

### Getting Help or Reporting an Issue

To report bugs/issues/feature requests, please file an
[issue](https://github.com/bcgov/simsbc/issues/).

### How to Contribute

If you would like to contribute to the package, please see our
[CONTRIBUTING](CONTRIBUTING.md) guidelines.

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.

### License

    Copyright 2023 Province of British Columbia

    Licensed under the Apache License, Version 2.0 (the &quot;License&quot;);
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an &quot;AS IS&quot; BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and limitations under the License.

------------------------------------------------------------------------

*This project was created using the
[bcgovr](https://github.com/bcgov/bcgovr) package.*
