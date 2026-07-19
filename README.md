<div align="center">

# DatasheetXML

### A Vendor-Neutral, Machine-Readable Format for Electronic Component Datasheets

**Specification Version 0.1 — Draft**

![status](https://img.shields.io/badge/status-draft-yellow)
![version](https://img.shields.io/badge/spec-v0.1-blue)
![license](https://img.shields.io/badge/license-TBD-lightgrey)

</div>

---

## Table of Contents

- [1. Introduction](#1-introduction)
- [2. Design Goals](#2-design-goals)
- [3. Design Principles](#3-design-principles)
  - [3.1 Canonical Source](#31-canonical-source)
  - [3.2 Separation of Content and Presentation](#32-separation-of-content-and-presentation)
  - [3.3 Semantic Markup](#33-semantic-markup)
- [4. File Structure](#4-file-structure)
- [5. Root Document](#5-root-document)
- [6. Metadata](#6-metadata)
- [7. Feature Summary](#7-feature-summary)
- [8. Package Information](#8-package-information)
- [9. Pin Description](#9-pin-description)
- [10. Electrical Characteristics](#10-electrical-characteristics)
- [11. Absolute Maximum Ratings](#11-absolute-maximum-ratings)
- [12. Timing Characteristics](#12-timing-characteristics)
- [13. Registers](#13-registers)
- [14. Memory Map](#14-memory-map)
- [15. Block Diagram](#15-block-diagram)
- [16. Package Drawings](#16-package-drawings)
- [17. Application Information](#17-application-information)
- [18. Change History](#18-change-history)
- [19. Cross References](#19-cross-references)
- [20. Units](#20-units)
- [21. Enumerations](#21-enumerations)
- [22. Validation](#22-validation)
- [23. Rendering](#23-rendering)
- [24. Versioning](#24-versioning)
- [25. Extensions](#25-extensions)
- [26. Benefits](#26-benefits)
- [27. Future Work](#27-future-work)
- [License](#license)

---

## 1. Introduction

**DatasheetXML** is a vendor-neutral, machine-readable format for describing electronic components. It is intended to become the canonical source of truth for a component's technical information.

Rather than publishing a PDF as the primary artifact, manufacturers publish a structured XML document. Human-readable outputs such as PDF, HTML, Markdown, and web pages are generated automatically using rendering templates (XSLT or equivalent).

```
datasheet.xml
        │
        ├── style-pdf.xsl
        ├── style-html.xsl
        ├── style-markdown.xsl
        └── style-ai.xsl

                ↓

      PDF / HTML / Markdown / AI View
```

The XML document contains only semantic information. Presentation is handled separately.

---

## 2. Design Goals

The specification aims to satisfy the following objectives:

- [x] Human editable
- [x] Machine readable
- [x] Vendor neutral
- [x] Schema validated
- [x] Version controlled
- [x] Diff friendly
- [x] Long-term archival
- [x] Extensible
- [x] AI friendly
- [x] Automatically renderable

---

## 3. Design Principles

### 3.1 Canonical Source

Every piece of information exists only once.

**Example:**

```xml
<OperatingVoltage>
    <Minimum unit="V">2.7</Minimum>
    <Maximum unit="V">3.6</Maximum>
</OperatingVoltage>
```

Every renderer derives its output from this data.

### 3.2 Separation of Content and Presentation

The XML never specifies:

- fonts
- colors
- page size
- margins
- table borders

Those belong in rendering styles.

### 3.3 Semantic Markup

Tags represent meaning rather than appearance.

✅ **Correct:**

```xml
<MaximumSupplyVoltage unit="V">3.6</MaximumSupplyVoltage>
```

❌ **Not:**

```xml
<BoldText>3.6V</BoldText>
```

---

## 4. File Structure

A datasheet package consists of:

```
STM32F407/
├── datasheet.xml
├── schema/
│   └── datasheet.xsd
├── styles/
│   ├── pdf.xsl
│   ├── html.xsl
│   └── markdown.xsl
├── images/
│   ├── package.png
│   └── blockdiagram.svg
└── examples/
```

---

## 5. Root Document

```xml
<Datasheet>
    ...
</Datasheet>
```

**Required attributes**

| Attribute | Description |
|---|---|
| `version` | Version of this datasheet document |
| `xmlns` | Schema namespace |
| `schemaVersion` | Version of the DatasheetXML schema in use |

**Example**

```xml
<Datasheet
    version="1.0"
    schemaVersion="1.0"
    xmlns="https://datasheet.org/schema/v1">
```

---

## 6. Metadata

Supported fields:

```
Manufacturer
Product
Family
Series
Part Number
Revision
Publication Date
Status
Lifecycle
Language
Copyright
License
```

**Example**

```xml
<Metadata>
    <Manufacturer>STMicroelectronics</Manufacturer>
    <Family>STM32F4</Family>
    <PartNumber>STM32F407VGT6</PartNumber>
    <Revision>8</Revision>
</Metadata>
```

---

## 7. Feature Summary

**Example**

```xml
<Features>
    <Feature>168 MHz Cortex-M4</Feature>
    <Feature>1 MB Flash</Feature>
    <Feature>192 KB SRAM</Feature>
    <Feature>USB OTG FS</Feature>
</Features>
```

---

## 8. Package Information

Supported fields:

```
Package
Dimensions
Pin Count
Thermal Resistance
Drawing
```

**Example**

```xml
<Package>
    <Name>LQFP100</Name>
    <Pins>100</Pins>
</Package>
```

---

## 9. Pin Description

Each pin is individually described.

```xml
<Pin number="42">
    <Name>PA0</Name>
    <Direction>Bidirectional</Direction>
    <Type>GPIO</Type>
    <Description>General Purpose I/O</Description>
</Pin>
```

---

## 10. Electrical Characteristics

Structured rather than tables.

```xml
<ElectricalCharacteristics>
    <Parameter>
        <Name>Supply Voltage</Name>
        <Minimum unit="V">2.7</Minimum>
        <Typical unit="V">3.3</Typical>
        <Maximum unit="V">3.6</Maximum>
    </Parameter>
</ElectricalCharacteristics>
```

---

## 11. Absolute Maximum Ratings

```xml
<AbsoluteMaximumRatings>
    <Rating>
        <Name>VDD</Name>
        <Minimum unit="V">-0.3</Minimum>
        <Maximum unit="V">4.0</Maximum>
    </Rating>
</AbsoluteMaximumRatings>
```

---

## 12. Timing Characteristics

```xml
<Timing>
    <Parameter>
        <Name>Clock Frequency</Name>
        <Maximum unit="MHz">168</Maximum>
    </Parameter>
</Timing>
```

---

## 13. Registers

The schema may embed or reference CMSIS-SVD information.

```xml
<Registers>
    <Import href="STM32F407.svd"/>
</Registers>
```

or

```xml
<Register>
    <Name>GPIO_MODER</Name>
    <Address>0x40020000</Address>
</Register>
```

---

## 14. Memory Map

```xml
<Memory>
    <Flash unit="KB">1024</Flash>
    <SRAM unit="KB">192</SRAM>
</Memory>
```

---

## 15. Block Diagram

```xml
<BlockDiagram>
    <Image>images/blockdiagram.svg</Image>
</BlockDiagram>
```

---

## 16. Package Drawings

```xml
<Mechanical>
    <Drawing file="LQFP100.svg"/>
</Mechanical>
```

---

## 17. Application Information

Narrative sections remain supported.

```xml
<ApplicationNotes>
    <Paragraph>
        Keep decoupling capacitors close to the device.
    </Paragraph>
</ApplicationNotes>
```

---

## 18. Change History

```xml
<RevisionHistory>
    <Revision>
        <Number>8</Number>
        <Date>2026-01-01</Date>
        <Description>
            Added USB timing specifications.
        </Description>
    </Revision>
</RevisionHistory>
```

---

## 19. Cross References

The document may reference external standards:

- CMSIS-SVD
- IBIS
- SPICE
- JEDEC
- IPC Footprints
- PCN Documents
- Errata
- Application Notes

---

## 20. Units

Every numerical value shall specify its unit explicitly.

**Example**

```xml
<Voltage unit="V">3.3</Voltage>
```

Supported unit types are defined in the schema.

---

## 21. Enumerations

Enumerated values shall use controlled vocabularies.

**Example — `Direction`**

```
Input
Output
Bidirectional
Power
Ground
Analog
Reserved
```

---

## 22. Validation

Every document must validate against an XSD.

Validation shall ensure:

- [x] required fields exist
- [x] units are valid
- [x] mandatory metadata is present
- [x] value types are correct
- [x] identifiers are unique
- [x] references resolve successfully

---

## 23. Rendering

Rendering is performed by stylesheet engines.

Possible outputs include:

- PDF
- HTML
- EPUB
- Markdown
- DOCX
- Plain text
- AI-optimized view

> **Rule:** No information may exist only in one rendered output.

---

## 24. Versioning

| Level | Meaning |
|---|---|
| **Major** | Incompatible schema changes |
| **Minor** | Additive elements |
| **Patch** | Corrections only |

---

## 25. Extensions

Custom vendor extensions are allowed using XML namespaces.

**Example**

```xml
<vendor:CalibrationData>
    ...
</vendor:CalibrationData>
```

Standard parsers ignore unknown namespaces while preserving interoperability.

---

## 26. Benefits

Compared with PDF:

- Structured semantics instead of visual layout
- Easier searching and querying
- Reliable automated validation
- Version-control friendly
- Better diff and merge behavior
- Simpler API generation
- Improved interoperability between EDA, PLM, ERP, and documentation systems
- Reduced ambiguity for AI and software tools
- Single canonical source for all published formats

---

## 27. Future Work

Future versions may define:

- [ ] JSON serialization
- [ ] Digital signatures
- [ ] Localization support
- [ ] Constraint language for design rules
- [ ] Embedded simulation models
- [ ] Component relationship graphs
- [ ] Semantic identifiers for specifications
- [ ] AI-oriented optimized renderers
- [ ] Standardized extension libraries

---

## License

*License terms for this specification have not yet been finalized (see [§6 Metadata](#6-metadata) → `License`). Proposed: publish the schema and examples under a permissive license (e.g. CC-BY 4.0 or Apache-2.0) to encourage manufacturer and tooling adoption.*

---

<div align="center">

**DatasheetXML Specification v0.1 — Draft**
Issues and proposals welcome via pull request.

</div>
