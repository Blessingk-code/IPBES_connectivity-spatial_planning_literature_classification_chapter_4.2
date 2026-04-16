# IPBES_connectivity-spatial_planning_literature_classification_chapter_4.2

**Overview**
This repository contains the data, code, and documentation supporting the literature classification process used in the IPBES Spatial Planning and Connectivity Assessment (Chapter 4.2).
The workflow applies a review-of-reviews approach, combined with rule-based keyword classification, to systematically organize scientific literature into thematic sections used for evidence synthesis.

**Objectives**
Identify and structure core literature on ecological connectivity
Classify literature into thematic categories aligned with IPBES chapter sections
Ensure transparency and reproducibility of the evidence base
Support synthesis on biodiversity, climate adaptation, socio-ecological systems, and risks

**Methodological Approach**
**1. Literature Identification**
Literature compiled using a systematic search strategy
Focus on:
Review articles
Meta-analyses
Assessment and policy reports
Supplemented using backward snowballing from key reviews

**2. Data Preparation**
Bibliographic data imported from CSV
Text fields combined (title, abstract, notes, journal, publisher)
Converted to lowercase for case-insensitive matching

**3. Keyword-Based Classification**
Section-specific keyword dictionary defined in Excel
Keywords grouped by thematic sections (e.g. biodiversity, climate, socio-ecological, risks)
Each document assigned based on keyword matches

**4. Assignment Rules**
Papers can be assigned to multiple sections
A primary section is determined based on highest keyword match count
Minimum threshold: ≥1 keyword match

**5. Outputs**
Full classification table
Primary section assignment
Section-level summaries
Section-specific reference lists

**Repository Structure**
data/raw/: Input datasets
data/processed/: Classification outputs
scripts/: R script for classification
docs/: Methodological documentation

**Reproducibility**

To reproduce the analysis:

Open scripts/ipbes_classification_pipeline.R
Update file paths if needed
Run the script in R

**Required R packages:**

dplyr
stringr
tidyr
purrr
readxl
openxlsx

**Notes**
This workflow prioritizes transparency over automation complexity
Keyword classification supports consistency but does not replace expert judgment
Final synthesis integrates expert evaluation and contextual interpretation

**Contact**
Blessing Kavhu
kavhublessing@gmail.com

**Acknowledgements**

Developed as part of the IPBES Spatial Planning and Connectivity Assessment.
