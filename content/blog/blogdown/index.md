---
authors:
- admin
categories: []
date: "2021-06-17T00:00:00Z"
draft: false
featured: false
image: 
  caption: ""
  focal_point: ""
projects: []
subtitle: 
summary: This blog is a step-by-step guide to building websites in R using blogdown
tags: []
title: R blogdown
toc: true
output:
  blogdown::html_page:
    toc: true
---
<!-- have to knit first if .Rmd --> 
<style type="text/css">

body {
  font-size: 14pt;
}

h1 { /* Header 1 */
  font-size: 26px;
  color: DarkBlue;
  font-weight: bold;
}


</style>

- This blog post is to help others build a website for the first time! (...and also to remind me of all the steps if I ever need to build another website in the future)
- I made this website and also helped to build the [UNSW CodeRs website](https://unsw-coders.netlify.app/) using blogdown


*<span style="color: red;">Please note: </span>  This blog was originally created using hugo_version '0.81.0' and with the "wowchemy/starter-academic", but there have been recent updates to this repo, so we have created a temporary repo for the time being.*


# Step 1: To create your website, you will need: Rstudio, Git, Github, and Netlify

- Rstudio: you can make changes to the content and serve the site locally
- Github: version control and syncs with Netlify
- Netlify: Builds and publishes the website using your Github repository

# Step 2: Rstudio, Git, Github Setup

- **Rstudio and Git must be installed**
- We recommend using Github rather than Github Desktop so you can follow along with these steps
- Login to Github or create an account and create a new repository with a readME file
- Click on the green Code button where you would go to download the repo, and click on the clipboard to copy the HTTPS url
- In Rstudio, go File &rarr; New Project.. &rarr; Version Control &rarr; Git &rarr; and paste the url that you copied from github (this will create an empty project with just your readME file)

# Step 3: Rstudio 
- Install blogdown and hugo (you may need to install devtools also)

```{r message=FALSE, warning=FALSE, eval=FALSE}
install.packages("blogdown")
library(blogdown)

install_hugo(version = "0.81.0", force = TRUE)
```

- Now you have to choose your hugo theme, so go to [https://themes.gohugo.io/](https://themes.gohugo.io/) and choose the theme you want 
- For the academic theme, select "Academic", click homepage, select "Skills" and then star on github. Copy the full repository name "wowchemy/starter-academic" 
  - *update: it looks like this repo is currently unavailable, so we'll be using one Tehilla created "tehillamo/academic-theme"*
- Go back to Rstudio to create your site with your selected theme. Just paste the theme name in like below
- Type y to serve and preview the site
- This may take a little while because it has to create the entire site. When it's done, you'll see all the files appear in Rstudio 

```{r eval=FALSE}
new_site(theme = "tehillamo/academic-theme")
```

- If you wish to stop serving your site, use this code:
```{r eval=FALSE}
stop_server()
```

- Next, you have to edit add a couple of lines to .gitignore (see code below)

```{r eval=FALSE}
file.edit(".gitignore")
```

```{r eval=FALSE}
# make sure you have all of this (you'll need to add the last 2 lines):
.Rproj.user
.Rhistory
.RData
.Ruserdata
.DS_Store 
Thumbs.db 
```

```{r eval=FALSE}
check_gitignore() # check that everything is good to go
```

![](check_gitignore.png)

- Notice the TODO - "When Netlify builds your site, you can safely add to .gitignore: /public/, /resources/"
- So, add public and resources to your .gitignore file and then check the content
```{r eval=FALSE}
# again, add the last 2 lines:
.Rproj.user
.Rhistory
.RData
.Ruserdata
.DS_Store
Thumbs.db
/public
/resources
```

```{r eval=FALSE}
check_content()
```

# Step 4: Stage, Commit, Push to Github

- Now go to Tools &rarr; shell and you'll see you're already in the correct directory
- The first time you **stage** everything you want to do it through the shell because there's so much. I've found it sometimes crashes if you try to stage too much through RStuido
- If this is your first time using Git, you'll need to enter your github details
- In the shell enter the following lines of code

```{r eval=FALSE}
git config --global user.name "jennysloane"
git config --global user.email "j.sloane@unsw.edu.au"
git add -A # this will add everything 
```

- Now you can close the shell 
- Back in Rstudio, click on **Commit** and everything should be checked off (because you've already staged everything in the shell). Leave a message (e.g. "First Commit") and click commit
- When you see the close button, you can click close 
- Finally, you want to **push** to github which may take a little while
- To make sure everything worked, go to your github account and check that it's all there
- ***Remember: Stage, Commit, Push***

# Step 5: Netlify 

- Go to [Netlify](https://www.netlify.com/) and login or sign up (sign up through Github)
- Click New site from Git (may need to give permissions)
- Click Continuous Deployment select Github
- Select the project with your website repo
- You should be able to keep the basic build default settings 
- But click on show advance and select new variable
- Key = HUGO_VERSION and Value = 0.81.0 (go to RStudio and type `hugo_version()` to make sure you enter the correct version number)
- Deploy site! 
- This should take less than a minute 
- Click preview to see site
- Netlify builds the site, so you don't have to build the site in Rstudio. You can serve site in Rstudio while you're working to see the changes but use Netlify to build the site
- Every time you push changes to Github, Netlify will update your site (i.e. continuous deployment)
- To change your website name, go to Site Overview &rarr; Site Settings &rarr; Site information &rarr; Change site name
- Update your new url in rstudio and then you can check netlify and hugo

```{r eval=FALSE}
rstudioapi::navigateToFile("config.yaml") 

check_netlify()
check_hugo()
```

##Your website should be up and running now :) 

# Additional Resources 
- To go along with this blog, Tehilla Ostrovsky and I have posted tutorials on YouTube for how to build an academic website using R blogdown. You can check out our YouTube Playlist [here](https://www.youtube.com/playlist?list=PLpZT7JPM8_GbPiX4ibrP7ogl7GyEofZMj). More videos to come! 
  - Please note these tutorials were also created using hugo version '0.81.0' and the "wowchemy/starter-academic" theme, so we recommend following the steps in this blog as it's been updated
- I also highly recommend checking out Alison Hill's blogdown [blog](https://alison.rbind.io/blog/2020-12-new-year-new-blogdown/). This is an incredibly useful resource and definitely helped me learn how to use blogdown
- And finally here's an [r-bloggers website](https://www.r-bloggers.com/2020/02/what-to-know-before-you-adopt-hugo-blogdown/) with useful information on Hugo and blogdown