concept "healthcare-dataset" {
  description = "A Cloud Healthcare API dataset containing healthcare data stores."
}

concept "healthcare-store" {
  description = "A FHIR, DICOM, HL7v2, or consent store in a Cloud Healthcare API dataset."
}


rule "healthcare-dataset" {
  match {
    type = "google_healthcare_dataset"
  }

  as = concept.healthcare-dataset
}

rule "healthcare-fhir-store" {
  match {
    type = "google_healthcare_fhir_store"
  }

  as = concept.healthcare-store

  context {
    as  = context.ownership
    to  = concept.healthcare-dataset
    via = source.dataset
  }
}

rule "healthcare-dicom-store" {
  match {
    type = "google_healthcare_dicom_store"
  }

  as = concept.healthcare-store

  context {
    as  = context.ownership
    to  = concept.healthcare-dataset
    via = source.dataset
  }
}

rule "healthcare-hl7v2-store" {
  match {
    type = "google_healthcare_hl7_v2_store"
  }

  as = concept.healthcare-store

  context {
    as  = context.ownership
    to  = concept.healthcare-dataset
    via = source.dataset
  }
}

rule "healthcare-consent-store" {
  match {
    type = "google_healthcare_consent_store"
  }

  as = concept.healthcare-store

  context {
    as  = context.ownership
    to  = concept.healthcare-dataset
    via = source.dataset
  }
}
