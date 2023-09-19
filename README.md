[![img](https://img.shields.io/badge/Lifecycle-Experimental-339999)](https://github.com/bcgov/repomountie/blob/master/doc/lifecycle-badges.md)

# simsbc

Access to biodiversity data and projects from British Columbia’s Species
Inventory Management System (SIMS).

SIMS is a web application for managing, submitting, and accessing
biodiversity data in British Columbia. It is designed for biologists
working for or in partnership with the Province, supporting
relationships between government, industry, Indigenous communities, and
consultants to advance natural resource stewardship.

This package is intended for biologists who want to load data from SIMS
into R, removing the need to manually export data from SIMS and import
it into R.

### Installation

You can install `simsbc` from GitHub using the
[remotes](https://cran.r-project.org/package=remotes) package.

``` r
install.packages("remotes")

# Install the simsbc package from GitHub
remotes::install_github("bcgov/simsbc")

library(simsbc)
```

### Authentication

You must login to the Species Inventory Management System using the
`login_sims()` function to access data.

``` r
login_sims()
```

This function opens a browser window where you can login by IDIR (for
internal government staff and contractors), Business BCeID, or Basic
BCeID. After you login, your temporary SIMS access token will be saved
to your R environment.

You will need to call `login_sims()` again if your token expires or you
clear your environment.

Unsure about how to login? [Learn about
BCeIDs](https://www.bceid.ca/aboutbceid/).

### Features

The Species Inventory Management System organizes ecological data into
Projects and Surveys, the latter of which contain species observations,
captured or marked animals, and other data.

- `get_my_projects()` returns a dataframe of Projects that you belong
  to. By default, these are Projects that you have created or have been
  invited to.
- `get_all_projects()` returns a dataframe of all Projects that you have
  access to, including those that you do not belong to. Some Projects
  are secured under the [Species and Ecosystems Data and Information
  Security
  Policy](https://www2.gov.bc.ca/gov/content/environment/natural-resource-stewardship/laws-policies-standards-guidance/data-information-security)
  and may not be returned.
- `get_project_details()` returns an object of class Project, which has
  various attributes including a name and objectives.
- `get_surveys()` returns a dataframe of Surveys from a specific
  Project.
- `get_survey_details()` returns an object of class Survey, which has
  various attributes including objectives, species of interest and start
  and end dates.

### Examples

``` r
## Login using an IDIR or BCeID through the browser
login()

## Get a dataframe of all Projects that you belong to
get_my_projects()

## Get the details of a specific Project, identified in the output of `get_my_projects()`
get_project_details(project_id = 1)

## Get a dataframe of all Surveys in a specific Project
get_surveys(project_id = 1)
```

### Coming Soon

We are building rapidly towards letting biologists import species
observations, after which we will build functions for retrieving species
observations.

### Project Status

This package is experimental. New features will be released as the
Species Inventory Management System develops.

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
