Basic Shiny application for use on Sage Bionetwork's Synapse web portal.

## Credits

- Maintainer: [thomasyu888](https://github.com/thomasyu888)
- Contributors: [allaway](https://github.com/allaway), [duncan-palmer](https://github.com/duncan-palmer), [jkiang13](https://github.com/jkiang13), [karawoo](https://github.com/karawoo), [kdaily](https://github.com/kdaily), [vpchung](https://github.com/vpchung)

## Introduction

Shiny applications are a powerful way to develop interactive data visualization and manipulation interfaces. However, when using with Synapse, user authentication is an issue - whomever the Shiny application is running as will determine the access that users visiting the application will have.

This solution allows to determine which user is currently logged into Synapse through the web browser. These credentials are passed on to the Shiny app, and that specific user is logged in. Subsequent interactions with Synapse to pull data for the Shiny interface then happens as that user.

:warning:**HOWEVER**:warning: The Synapse R client, [synapser](https://r-docs.synapse.org/), stores authentication information in a
location that is global to the R process. This means that if one user connects
to a Shiny app, and then another user connects from another browser or computer, the second
user's authentication will supersede the first's. This can cause
hard-to-diagnose errors, and is a security issue. There are 3 ways to work
around this issue:

1. Ensure that each user gets a separate R process by customizing the
   [utilization scheduler](https://support.rstudio.com/hc/en-us/articles/220546267-Scaling-and-Performance-Tuning-Applications-in-Shiny-Server-Pro)
   (only available for Shiny Server Pro).
1. Write your app so that it logs in before doing any operation that interacts
   with Synapse. Essentially this means writing wrappers for every synapser
   function you use, e.g.:
    
   ```r
   authSynGet <- function(...) {
     synLogin(sessionToken = input$cookie)
     synGet(...)
   }
   ```
   
   Placing a call to `synLogin()` before `synGet()` directly in your server
   function is not necessarily sufficient, as it is still possible someone else
   could log in between when your `synLogin()` and `synGet()` are executed.
1. Instead of using synapser, use the [Synapse Python client](https://python-docs.synapse.org/) + [reticulate](https://rstudio.github.io/reticulate/). The
   Python client allows for creating multiple client objects, and therefore
   multiple authenticated users.  Please see the [reticulate branch](https://github.com/Sage-Bionetworks/SynapseShinyApp/tree/reticulate) for implementation details.

## Usage

To create a new Shiny application based on this structure, do *not* fork this repository directly on GitHub. Instead, please use GitHub's importer following the instructions [below](#creating-a-repository).
 
### Creating a New Shiny App Repository

1.  Go to [GitHub's importer](https://github.com/new/import?import_url=https://github.com/Sage-Bionetworks/SynapseShinyApp.git) and paste in this repository's clone URL (https://github.com/Sage-Bionetworks/SynapseShinyApp.git).
1.  Choose a name for your repository.
1.  Select the owner for your repository (This will probably be you, but may instead be an organization you belong to).

You can now click "Begin Import". When the process is done, you can click "Continue to repository" to visit your newly-created repository.

### Notes

If you are using a `navbarPage` instead of a `fluidPage` in your `ui.R`, use of this code: 
```
tags$head(
    singleton(
      includeScript("www/readCookie.js")
    )
  ),
``` 
will cause create a default ghost tab. Instead, you should replace the above code with this snippet: 
```
header=list(tags$head(includeScript("www/readCookie.js"))),
```
