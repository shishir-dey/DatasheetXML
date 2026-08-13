<div align="center">

# DatasheetXML

### A Vendor-Neutral, Machine-Readable Format for Electronic Component Datasheets

**Specification Version 0.2 — Draft**

**Author: Shishir Dey**

![status](https://img.shields.io/badge/status-draft-yellow)
![version](https://img.shields.io/badge/spec-v0.2-blue)
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
- [7. Component Specifications (CDD)](#7-component-specifications-cdd)
- [8. Feature Summary](#8-feature-summary)
- [9. Package Information](#9-package-information)
- [10. Pin Description](#10-pin-description)
- [11. Electrical Characteristics](#11-electrical-characteristics)
- [12. Absolute Maximum Ratings](#12-absolute-maximum-ratings)
- [13. Timing Characteristics](#13-timing-characteristics)
- [14. Registers](#14-registers)
- [15. Memory Map](#15-memory-map)
- [16. Block Diagram](#16-block-diagram)
- [17. Package Drawings](#17-package-drawings)
- [18. Application Information](#18-application-information)
- [19. Change History](#19-change-history)
- [20. Cross References](#20-cross-references)
- [21. Units](#21-units)
- [22. Enumerations](#22-enumerations)
- [23. Validation](#23-validation)
- [24. Rendering](#24-rendering)
- [25. Versioning](#25-versioning)
- [26. Extensions](#26-extensions)
- [27. Benefits](#27-benefits)
- [28. Future Work](#28-future-work)
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

A DatasheetXML repository keeps its canonical schemas separate from examples:

```
DatasheetXML/
├── schema/
│   ├── datasheet.xsd
│   ├── component-cdd.xsd
│   └── component-specifications.xsd
└── examples/
    ├── LM5116/
    │   ├── datasheet.xml
    │   └── style-pdf.xsl
    └── generic-resistor/
        └── datasheet.xml
```

`schema/datasheet.xsd` is the public validation entry point. The example-local XSD
files are compatibility entry points that include this canonical schema.

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
    schemaVersion="0.2"
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

## 7. Component Specifications (CDD)

DatasheetXML describes any electronic or electromechanical component, not only
microcontrollers or integrated circuits. `ComponentSpecifications` adapts the
provided IEC CDD-style property model into the DatasheetXML namespace. Its
`identification` section is required when `ComponentSpecifications` is present;
all other sections are optional so a document only states facts that apply to the
part.

The twelve section keys, in schema order, are:

| Section | Purpose |
|---|---|
| `identification` | Classification, internal identifiers, alternates, and optional placed-instance designator |
| `electrical` | Ratings and electrical properties such as resistance, capacitance, frequency, or ESD |
| `mechanical` | Package, footprint, dimensions, mounting, termination, and CAD reference |
| `thermal` | Operating/storage ranges, thermal resistance, derating, and reflow compatibility |
| `material` | Body, finish, substrate, encapsulant, MSL, and substance composition |
| `environmental` | RoHS, REACH, halogen, conflict-minerals, ingress, humidity, and related declarations |
| `reliability` | MTBF, failure rate, lifetime, qualifications, failure modes, and endurance |
| `regulatory` | Certifications, trade classifications, origin, export status, and standards |
| `manufacturing` | Assembly process, solderability, orientation, process capability, and traceability |
| `commercial` | Lifecycle, lead time, order quantities, pricing, distributors, and alternates |
| `packaging` | Packing method, reel/tape details, orientation, dry pack, and labeling |
| `documentation` | Datasheets, application notes, CAD, certificates, PCNs, SDS, and revisions |

### 7.1 Designator categories

The `designatorCategory` value is required and uses this controlled vocabulary.
`referenceDesignator` is optional because a manufacturer datasheet describes a
part, while a value such as `R12` describes one placed instance.

| Code | Category | Code | Category |
|---|---|---|---|
| `A` | Removable Sub-assembly or Plug-in Module | `AE` | Antenna |
| `BT` | Battery | `C` | Capacitor |
| `D` | Diode | `DS` | Display |
| `F` | Fuse | `FB` | Ferrite Bead |
| `FD` | Fiducial | `FL` | Filter |
| `H` | Hardware | `J` | Jack |
| `JP` | Jumper / Link | `K` | Relay |
| `L` | Inductor | `LS` | Loudspeaker or Buzzer |
| `M` | Motor | `MK` | Microphone |
| `P` | Plug | `Q` | Transistor |
| `R` | Resistor | `RN` | Resistor Network |
| `RT` | Thermistor | `RV` | Varistor |
| `SW` | Switch | `T` | Transformer |
| `TC` | Thermocouple | `TJ` | Thermal Jumper |
| `TP` | Test Point | `U` | Integrated Circuit |
| `Y` | Crystal / Oscillator | `Z` | Zener Diode |

### 7.2 CDD properties

Measured or classified properties use a reusable IEC 61360-style wrapper. It can
carry a scalar value, unit, data type, application condition, tolerance, numeric
minimum/typical/maximum, definition, IRDI, and source.

```xml
<ComponentSpecifications>
    <identification>
        <designatorCategory>R</designatorCategory>
        <designatorCategoryLabel>Resistor</designatorCategoryLabel>
    </identification>
    <electrical>
        <resistance>
            <value>100</value>
            <unit>ohm</unit>
            <dataType>REAL_MEASURE</dataType>
            <tolerance>+/-1%</tolerance>
        </resistance>
    </electrical>
</ComponentSpecifications>
```

Identity already present in `Metadata` should not be repeated in
`identification`. The overlapping CDD identification fields remain available for
lossless import of existing CDD records.

The full passive-component example at
`examples/generic-resistor/datasheet.xml` exercises all twelve sections. The CDD
schema authored by Shishir Dey is maintained at `schema/component-cdd.xsd`; its
DatasheetXML namespace adaptation is `schema/component-specifications.xsd`.

---

## 8. Feature Summary

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

## 9. Package Information

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

## 10. Pin Description

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

## 11. Electrical Characteristics

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

## 12. Absolute Maximum Ratings

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

## 13. Timing Characteristics

```xml
<Timing>
    <Parameter>
        <Name>Clock Frequency</Name>
        <Maximum unit="MHz">168</Maximum>
    </Parameter>
</Timing>
```

---

## 14. Registers

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

## 15. Memory Map

```xml
<Memory>
    <Flash unit="KB">1024</Flash>
    <SRAM unit="KB">192</SRAM>
</Memory>
```

---

## 16. Block Diagram

```xml
<BlockDiagram>
    <Image>images/blockdiagram.svg</Image>
</BlockDiagram>
```

---

## 17. Package Drawings

```xml
<Mechanical>
    <Drawing file="LQFP100.svg"/>
</Mechanical>
```

---

## 18. Application Information

Narrative sections remain supported.

```xml
<ApplicationNotes>
    <Paragraph>
        Keep decoupling capacitors close to the device.
    </Paragraph>
</ApplicationNotes>
```

---

## 19. Change History

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

## 20. Cross References

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

## 21. Units

Every measured numerical value should specify its unit explicitly. Counts,
dimensionless ratios, dates, and identifiers do not require a unit.

**Example**

```xml
<Voltage unit="V">3.3</Voltage>
```

Units are strings in schema version 0.2 so domain-specific units remain usable. A
normalized unit vocabulary is planned as a future additive constraint.

---

## 22. Enumerations

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

## 23. Validation

Every document must validate against an XSD.

Validation shall ensure:

- [x] required fields exist
- [x] units are valid
- [x] mandatory metadata is present
- [x] value types are correct
- [x] identifiers are unique
- [x] references resolve successfully

---

## 24. Rendering

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

## 25. Versioning

| Level | Meaning |
|---|---|
| **Major** | Incompatible schema changes |
| **Minor** | Additive elements |
| **Patch** | Corrections only |

---

## 26. Extensions

Custom vendor extensions are allowed using XML namespaces.

**Example**

```xml
<vendor:CalibrationData>
    ...
</vendor:CalibrationData>
```

Standard parsers ignore unknown namespaces while preserving interoperability.

---

## 27. Benefits

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

## 28. Future Work

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

License terms for this specification have not yet been finalized. Proposed: publish the schema and examples under a permissive license (e.g. CC-BY 4.0 or Apache-2.0) to encourage manufacturer and tooling adoption.
