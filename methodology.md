**Methodology: Literature classification pipeline**

**Approach**
This workflow follows a review-of-reviews (umbrella review) methodology combined with rule-based text classification.

**Key Steps**

**Step 1: Input Data**
- Bibliographic dataset (CSV)
- Keyword dictionary (Excel)

**Step 2: Text Construction**
A unified text field is created by combining:
- Title
- Abstract
- Notes
- Journal
- Publisher
All text is converted to lowercase.

**Step 3: Keyword Dictionary**
- Keywords defined per section
- Stored as semi-colon separated lists
- Processed into vectors for matching

**Step 4: Matching Algorithm**
- Case-insensitive keyword detection
- Exact matching using fixed string detection
- Count of keyword hits per document per section

**Step 5: Classification Logic**
- Documents assigned to sections if:
- Keyword hits ≥ threshold (default = 1)
- Multi-label classification allowed

**Step 6: Primary Assignment**
- Section with highest keyword count selected
- Ties excluded to ensure single assignment

**Step 7: Outputs Generated**
- Full classification matrix
- Primary assignment table
- Section summary counts
- Section-specific reference exports

**Limitations**
- Keyword-based classification may:
- Miss context-dependent meanings
- Overrepresent frequently used terms
- Does not capture semantic nuance
- Requires expert validation

**Strengths**
- Transparent and reproducible
- Scalable to large datasets
- Easily auditable
- Aligns with IPBES evidence standards

**Role in Assessment**

Outputs from this pipeline:
- Structured the evidence base
- Supported thematic synthesis
- Informed confidence and gap assessments
