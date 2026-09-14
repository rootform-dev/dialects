concept "pages-project" {
  description = "A Cloudflare Pages application project."
}

concept "pages-domain" {
  description = "A custom domain serving a Cloudflare Pages project."
}




rule "pages-project" {
  match {
    type = "cloudflare_pages_project"
  }

  as = concept.pages-project
}

rule "pages-domain" {
  match {
    type = "cloudflare_pages_domain"
  }

  as = concept.pages-domain

  contribution {
    to  = concept.pages-project
    via = source.project_name
  }
}
