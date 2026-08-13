<div align="center">

# DatasheetXML

### A Vendor-Neutral, Machine-Readable Format for Electronic Component Datasheets

**Specification Version 0.3 — Draft**

**Author: Shishir Dey**

![status](https://img.shields.io/badge/status-draft-yellow)
![version](https://img.shields.io/badge/spec-v0.3-blue)
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
- [4. Root Document](#4-root-document)
  - [4.1 Reusable Property Values](#41-reusable-property-values)
- [5. Identification](#5-identification)
- [6. Electrical](#6-electrical)
- [7. Mechanical](#7-mechanical)
- [8. Thermal](#8-thermal)
- [9. Material](#9-material)
- [10. Environmental](#10-environmental)
- [11. Reliability](#11-reliability)
- [12. Regulatory](#12-regulatory)
- [13. Manufacturing](#13-manufacturing)
- [14. Commercial](#14-commercial)
- [15. Packaging](#15-packaging)
- [16. Documentation](#16-documentation)
- [17. EDA Models](#17-eda-models)
- [18. Change History](#18-change-history)
- [19. Cross References](#19-cross-references)
- [20. Validation](#20-validation)
- [21. Rendering](#21-rendering)
- [22. Versioning](#22-versioning)
- [23. Future Work](#23-future-work)
- [License](#license)

---

## 1. Introduction

**DatasheetXML** is a vendor-neutral, machine-readable format for describing
electronic and electromechanical components. It is intended to become the
canonical source of truth for a component's technical, manufacturing,
compliance, commercial, and documentation data.

Rather than publishing a PDF as the primary artifact, manufacturers publish a
structured XML document. Human-readable outputs such as PDF, HTML, Markdown,
and web pages are generated automatically using rendering templates.

```text
datasheet.xml
        │
        ├── style-pdf.xsl
        ├── style-html.xsl
        ├── style-markdown.xsl
        └── style-ai.xsl

                ↓

      PDF / HTML / Markdown / AI View
```

The XML document contains semantic information only. Presentation is handled
separately.

---

## 2. Design Goals

The specification aims to be:

- [x] Human editable
- [x] Machine readable
- [x] Vendor neutral
- [x] Schema validated
- [x] Version controlled
- [x] Diff friendly
- [x] Suitable for long-term archival
- [x] AI friendly
- [x] Automatically renderable

---

## 3. Design Principles

### 3.1 Canonical Source

Every piece of information exists only once. Renderers and downstream tools
derive their output from the same structured value.

```xml
<voltageRating>
    <minValue>2.7</minValue>
    <typValue>3.3</typValue>
    <maxValue>3.6</maxValue>
    <unit>V</unit>
    <dataType>REAL_MEASURE</dataType>
</voltageRating>
```

### 3.2 Separation of Content and Presentation

The XML never specifies fonts, colors, page sizes, margins, or table borders.
Those belong in rendering styles.

### 3.3 Semantic Markup

Tags represent meaning rather than appearance.

```xml
<maxJunctionTemperature>
    <value>150</value>
    <unit>degC</unit>
</maxJunctionTemperature>
```

---

## 4. Root Document

The public validation entry point is `schema/datasheet.xsd`. A document uses the
`Datasheet` root element and places the thirteen component-data sections directly
inside it in the order shown below.

```xml
<Datasheet
    xmlns="https://datasheet.org/schema/v1"
    version="1.0"
    schemaVersion="0.3">
    <identification>
        <referenceDesignator>R104</referenceDesignator>
        <designatorCategory>R</designatorCategory>
        <manufacturerPartNumber>RC0402FR-0710KL</manufacturerPartNumber>
        <manufacturer>Yageo</manufacturer>
    </identification>
    <electrical>
        <resistance>
            <value>10000</value>
            <unit>ohm</unit>
            <dataType>REAL_MEASURE</dataType>
            <tolerance>+/-1%</tolerance>
        </resistance>
    </electrical>
</Datasheet>
```

`identification` is required. All other sections are optional. The `version`
attribute identifies the revision of the document itself; `schemaVersion` is
required and fixed to `0.3` by this schema release.

### 4.1 Reusable Property Values

Measured and classified data uses a reusable property structure. Every field is
optional so the document can preserve the information available from its source.

| Field | Type | Meaning |
|---|---|---|
| `value` | Simple value | Scalar or textual value |
| `unit` | String | Unit associated with the value |
| `dataType` | Controlled string | `INTEGER_MEASURE`, `REAL_MEASURE`, `STRING`, `BOOLEAN`, `ENUM`, `RANGE`, `RATIONAL_MEASURE`, or `INTEGER_COUNT` |
| `conditionOfApplication` | String | Condition under which the property applies |
| `tolerance` | String | Stated tolerance |
| `minValue`, `typValue`, `maxValue` | Number | Numeric range and typical value |
| `definition` | String | Human-readable definition |
| `irdi` | String | IEC identifier in IRDI form |
| `source` | String | Origin of the property value |

---

## 5. Identification

`identification` gives the unique identity and classification of the component
instance. `referenceDesignator` and `designatorCategory` are required.

| Field | Type | Notes |
|---|---|---|
| `referenceDesignator` | String | Must contain a supported category prefix, digits, and an optional letter suffix, such as `C104`, `U3`, or `RN2` |
| `designatorCategory` | Controlled string | `A`, `AE`, `BT`, `C`, `D`, `DS`, `F`, `FB`, `FD`, `FL`, `H`, `J`, `JP`, `K`, `L`, `LS`, `M`, `MK`, `P`, `Q`, `R`, `RN`, `RT`, `RV`, `SW`, `T`, `TC`, `TJ`, `TP`, `U`, `Y`, or `Z` |
| `designatorCategoryLabel` | String | Human-readable category label |
| `manufacturerPartNumber` | String | Manufacturer-assigned part number |
| `manufacturer` | String | Manufacturer name |
| `internalPartNumber` | String | Organization-internal part or SKU |
| `genericPartFamily` | String | Component class or plain-text family |
| `irdiClassId` | String | IRDI of the component class |
| `description` | String | Component description |
| `revision` | String | Component revision |
| `alternatePartNumbers` | List of strings | Alternate manufacturer part numbers |
| `eccnClassification` | String | Export-control classification |

---

## 6. Electrical

`electrical` contains electrical ratings and characteristics.

| Field | Type | Notes |
|---|---|---|
| `voltageRating` | Property | Rated voltage |
| `currentRating` | Property | Rated current |
| `powerRating` | Property | Rated power |
| `resistance` | Property | Resistance value or range |
| `capacitance` | Property | Capacitance value or range |
| `inductance` | Property | Inductance value or range |
| `impedance` | Property | Impedance value or range |
| `frequencyRange` | Property | Supported frequency range |
| `tolerance` | Property | Electrical tolerance |
| `temperatureCoefficient` | Property | Change in value with temperature |
| `dielectricType` | String | For example, `C0G/NP0`, `X7R`, or `Y5V` |
| `polarized` | Boolean | Whether the component is polarized |
| `pinCount` | Integer | Number of component pins |
| `logicFamily` | String | Logic family name |
| `switchingCharacteristics` | Property | Switching behavior or limits |
| `insulationResistance` | Property | Insulation resistance |
| `dielectricWithstandingVoltage` | Property | Dielectric withstand rating |
| `esdRating` | Property | Electrostatic-discharge rating |
| `additionalProperties` | List of properties | Component-specific electrical properties not listed above |

---

## 7. Mechanical

`mechanical` describes physical form, dimensions, and mounting characteristics.

| Field | Type | Notes |
|---|---|---|
| `packageType` | String | For example, `0402`, `SOIC-8`, `TO-220`, or `QFN-32` |
| `footprint` | String | IPC-7351 land-pattern name or reference |
| `dimensions` | Object | Property-valued `length`, `width`, `height`, `diameter`, and `leadPitch` |
| `mass` | Property | Component mass |
| `mountingType` | Controlled string | `SMT`, `THT`, `Press-fit`, `Panel-mount`, `Chassis-mount`, `Free-standing`, or `Other` |
| `terminationStyle` | String | For example, gull-wing, J-lead, BGA ball, axial, or radial |
| `mechanicalTolerance` | Property | Dimensional or mechanical tolerance |
| `connectorGender` | Controlled string | `Male`, `Female`, or `N/A` |
| `keying` | String | Connector or package keying information |
| `actuationForce` | Property | Actuation force for switches or connectors |
| `vibrationResistance` | Property | Vibration-resistance rating |
| `shockResistance` | Property | Shock-resistance rating |
| `cadModelRef` | String | Pointer to a CAD or STEP model |

---

## 8. Thermal

`thermal` records temperature ratings and thermal-transfer characteristics.

| Field | Type | Notes |
|---|---|---|
| `operatingTemperatureRange` | Property | Permitted operating-temperature range |
| `storageTemperatureRange` | Property | Permitted storage-temperature range |
| `thermalResistanceJunctionAmbient` | Property | Junction-to-ambient thermal resistance, Rth(j-a) |
| `thermalResistanceJunctionCase` | Property | Junction-to-case thermal resistance, Rth(j-c) |
| `maxJunctionTemperature` | Property | Maximum junction temperature |
| `derating` | Property | Derating curve or rule |
| `thermalConductivity` | Property | Thermal conductivity |
| `reflowProfileCompatibility` | String | Reference to a J-STD-020 reflow classification or profile |

---

## 9. Material

`material` describes bulk material, plating, finish, and construction.

| Field | Type | Notes |
|---|---|---|
| `bodyMaterial` | String | Component body material |
| `terminationFinish` | String | For example, matte tin, gold, or NiPdAu |
| `substrateMaterial` | String | Substrate material |
| `encapsulantMaterial` | String | Encapsulant material |
| `flammabilityRating` | String | UL 94 classification, such as `V-0` |
| `moistureSensitivityLevel` | String | J-STD-020 MSL rating, such as `MSL 3` |
| `colorFinish` | String | Component color or finish |
| `magneticProperties` | String | Magnetic-material characteristics |
| `materialComposition` | List of objects | Entries containing `substance`, `casNumber`, and `massFraction` |

---

## 10. Environmental

`environmental` captures environmental compliance and operating-environment
tolerance.

| Field | Type | Notes |
|---|---|---|
| `rohsCompliant` | Boolean | RoHS compliance status |
| `rohsVersion` | String | For example, `RoHS 3 (EU 2015/863)` |
| `reachCompliant` | Boolean | REACH compliance status |
| `reachSvhcListDate` | Date | Date of the applicable REACH SVHC list |
| `halogenFree` | Boolean | Halogen-free status |
| `conflictMineralsStatus` | Controlled string | `DRC Conflict-Free`, `Not Conflict-Free`, or `Not Assessed` |
| `ingressProtectionRating` | String | IP code, such as `IP67` |
| `humidityRating` | Property | Humidity tolerance or rating |
| `altitudeRating` | Property | Altitude tolerance or rating |
| `chemicalResistance` | String | Chemical-resistance description |
| `uvResistance` | Boolean | UV-resistance status |
| `californiaProp65` | Boolean | California Proposition 65 status |

---

## 11. Reliability

`reliability` stores lifetime, failure-rate, qualification, and endurance data.

| Field | Type | Notes |
|---|---|---|
| `mtbf` | Property | Mean time between failures |
| `failureRate` | Property | Failure rate, such as FIT per 1 billion device-hours |
| `ratedLifetime` | Property | Rated service lifetime |
| `qualificationStandard` | List of strings | Qualification standards, such as `AEC-Q200` or `MIL-STD-883` |
| `gradeLevel` | String | For example, Automotive Grade 1, Industrial, Consumer, or Military |
| `burnInTested` | Boolean | Whether burn-in testing was performed |
| `predictedFailureModes` | List of strings | Predicted component failure modes |
| `endurance` | Object | Property-valued `cycleCount` and a `testMethod` string |

---

## 12. Regulatory

`regulatory` contains certifications, export-control data, and standards
references.

| Field | Type | Notes |
|---|---|---|
| `certifications` | List of strings | Certifications such as UL, CE, FCC Part 15, CSA, or CCC |
| `certificateNumbers` | List of strings | Identifiers for applicable certificates |
| `eccn` | String | Export Control Classification Number |
| `htsCode` | String | Harmonized Tariff Schedule code |
| `countryOfOrigin` | String | Manufacturing country of origin |
| `exportLicenseRequired` | Boolean | Whether an export license is required |
| `ituCompliance` | String | ITU compliance information |
| `iecStandardRef` | List of strings | Governing IEC standards, such as `IEC 60384-1` |

---

## 13. Manufacturing

`manufacturing` describes process, assembly, and production characteristics.

| Field | Type | Notes |
|---|---|---|
| `assemblyProcess` | Controlled string | `SMT-Reflow`, `THT-Wave`, `THT-Selective`, `Manual`, `Press-fit`, or `Other` |
| `solderReflowProfile` | String | Solder-reflow profile identifier or description |
| `leadFreeProcessCompatible` | Boolean | Lead-free process compatibility |
| `peakReflowTemperature` | Property | Maximum reflow temperature |
| `solderabilityStandard` | String | Solderability standard, such as `J-STD-002` |
| `placementOrientation` | String | Required component placement orientation |
| `testCoverage` | String | For example, AOI plus ICT or 100% functional test |
| `yieldRate` | Property | Manufacturing yield rate |
| `processCapabilityIndex` | Property | Process capability index, Cpk |
| `traceabilityMethod` | String | For example, lot-code marking or date code plus serial number |

---

## 14. Commercial

`commercial` stores sourcing, pricing, and lifecycle data.

| Field | Type | Notes |
|---|---|---|
| `lifecycleStatus` | Controlled string | `Active`, `NRND`, `EOL`, `Obsolete`, `Preview`, or `Unknown` |
| `lastTimeBuyDate` | Date | Last date on which the component may be ordered |
| `endOfLifeDate` | Date | Component end-of-life date |
| `leadTimeWeeks` | Number | Procurement lead time in weeks |
| `minimumOrderQuantity` | Integer | Minimum order quantity |
| `standardPackQuantity` | Integer | Standard pack quantity |
| `priceBreaks` | List of objects | Entries containing integer `quantity`, numeric `unitPrice`, and string `currency` |
| `distributors` | List of objects | Entries containing `name`, `sku`, `stockQuantity`, and `url` |
| `alternateSources` | List of strings | Cross-reference or second-source part numbers |
| `obsolescenceRiskScore` | Number | Computed component-obsolescence risk score |

---

## 15. Packaging

`packaging` describes shipping and handling packaging, distinct from the
component body described by `mechanical`.

| Field | Type | Notes |
|---|---|---|
| `packingMethod` | Controlled string | `Tape and Reel`, `Tube`, `Tray`, `Bulk`, `Cut Tape`, or `Bag` |
| `reelSize` | String | For example, `7in` or `13in` |
| `quantityPerReel` | Integer | Number of components per reel |
| `tapeWidth` | Property | Carrier-tape width |
| `tapePitch` | Property | Carrier-tape pitch |
| `orientation` | String | Pin-1 or component orientation in carrier tape per EIA-481 |
| `dryPackRequired` | Boolean | Whether dry packaging is required |
| `packagingMaterial` | String | Packaging material |
| `labelingStandard` | String | For example, `IPC-1782` or `ANSI MH10.8.2` |

---

## 16. Documentation

`documentation` describes supporting documents using a controlled document type.

| Field | Type | Notes |
|---|---|---|
| `documents` | List of objects | Each entry contains required `documentType` and `url` fields, with optional `title`, `documentNumber`, `revision`, and `date` |
| `complianceCertificates` | List of URIs | Compliance-certificate locations |
| `revisionHistory` | List of objects | Entries containing `revision`, `date`, and `notes` |

Supported `documentType` values are:

| Document type | Description |
|---|---|
| `Application Note` | Practical guidance for applying or integrating the component |
| `Technical Note` | Focused technical information or implementation details |
| `Errata` | Known defects, limitations, and corrections |
| `PCN` | Product Change Notice |

---

## 17. EDA Models

`edaModels` provides direct links to machine-readable engineering assets.
Each field accepts one or more URIs and is optional, including `svd` when it does
not apply to the component.

| Field | Type | Notes |
|---|---|---|
| `bsdl` | List of URIs | Boundary-Scan Description Language models |
| `ibis` | List of URIs | I/O Buffer Information Specification models |
| `spice` | List of URIs | SPICE simulation models |
| `svd` | List of URIs | System View Description files, when applicable |
| `symbol` | List of URIs | Schematic symbol files |
| `footprint` | List of URIs | PCB footprint or land-pattern files |
| `threeDModel` | List of URIs | 3D component models |

---

## 18. Change History

Document changes are recorded in `documentation/revisionHistory`.

```xml
<documentation>
    <revisionHistory>
        <entry>
            <revision>1.1</revision>
            <date>2026-08-13</date>
            <notes>Updated the resistance tolerance.</notes>
        </entry>
    </revisionHistory>
</documentation>
```

---

## 19. Cross References

Cross references are represented by the fields closest to their meaning:

- IEC class identifiers use `identification/irdiClassId`.
- CAD model references use `mechanical/cadModelRef`; downloadable 3D models use
  `edaModels/threeDModel`.
- Certifications and IEC standards use `regulatory`.
- Application notes, technical notes, errata, PCNs, and certificates use
  `documentation`.
- Simulation models, device descriptions, symbols, footprints, and 3D models use
  `edaModels`.

---

## 20. Validation

Every document must validate against `schema/datasheet.xsd`. The schema checks:

- the required root attributes and identification fields;
- element names, ordering, and value types;
- reference-designator syntax;
- controlled values for categories, processes, statuses, and formats;
- dates and URIs; and
- the numeric types used by property ranges and commercial data.

Example using an XML Schema validator:

```sh
xmllint --noout --schema schema/datasheet.xsd datasheet.xml
```

---

## 21. Rendering

Rendering is performed by stylesheet engines. Possible outputs include PDF,
HTML, EPUB, Markdown, DOCX, plain text, and AI-optimized views.

> **Rule:** No information may exist only in one rendered output.

---

## 22. Versioning

| Level | Meaning |
|---|---|
| **Major** | Incompatible schema changes |
| **Minor** | Additive elements |
| **Patch** | Corrections only |

The current specification version is **0.3**.

---

## 23. Future Work

Future versions may define:

- [ ] Digital signatures
- [ ] Localization support
- [ ] Constraint language for design rules
- [ ] Component relationship graphs
- [ ] Semantic identifiers for specifications

---

## License

License terms for this specification have not yet been finalized. A permissive
license such as CC BY 4.0 or Apache 2.0 is proposed to encourage manufacturer and
tooling adoption.
