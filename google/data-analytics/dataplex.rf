concept "dataplex-lake" {
  description = "A Dataplex lake organizing governed data domains."
}

concept "dataplex-zone" {
  description = "A Dataplex zone organizing assets within a lake."
}

concept "dataplex-asset" {
  description = "A data asset governed through Dataplex."
}


rule "dataplex-lake" {
  match {
    type = "google_dataplex_lake"
  }

  as = concept.dataplex-lake
}

rule "dataplex-zone" {
  match {
    type = "google_dataplex_zone"
  }

  as = concept.dataplex-zone

  context {
    as  = context.ownership
    to  = concept.dataplex-lake
    via = source.lake
  }
}

rule "dataplex-asset" {
  match {
    type = "google_dataplex_asset"
  }

  as = concept.dataplex-asset
}

rule "dataplex-data-asset" {
  match {
    type = "google_dataplex_data_asset"
  }

  as = concept.dataplex-asset
}
