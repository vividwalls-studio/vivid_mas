Date : May 2015
Semantics of Business Vocabulary and 
Business Rules (SBVR)
Version 1.3  
OMG Document Number:  formal/2015-05-07
Standard document URL:  http://www.omg.org/spec/SBVR/1.3/PDF

Normative Machine C onsumable Files:  
http://www.omg.org /spec/SBVR/20141201
http://www.omg.org/spec/SBVR/20141201/ SBVR-model.xml
http://www.omg.org/spec/SBVR/20141201/SBVR.xsd
http://www.omg.org/spe c/SBVR/20141201/SBVR.xmlOBJECT 
MANAGEMENT GROUPOBJECT MANAGEMENT GROUP
Copyright © 2005-2007, Business Rule Solutions, LLC
Copyright © 2005-2007, Business Semantics LtdCopyright © 2005-2007, Fujitsu LtdCopyright © 2005-2007, Hendryx & AssociatesCopyright © 2005-2007, LibRTCopyright © 2005-2007, KnowGravity IncCopyright © 2005-2007, Model SystemsCopyright © 2005-2007, Neumont UniversityCopyright © 1997-2015, Object Management GroupCopyright © 2005-2007, Unisys Corporation
USE OF SPECIFICATION - TERMS, CONDITIONS & NOTICES
The material in this document details an Object Management  Group specification in accordance with the terms, conditions and 
notices set forth below. This document does not represent a comm itment to implement any portion of this specification in any 
company’s products. The information contained in this document is subject to change without notice.
LICENSES
The companies listed above have granted to  the Object Management Group, Inc. (OMG ) a nonexclusive, roya lty-free, paid up, 
worldwide license to copy and distribute this document and to modify this document and distribute copies of the modified version. Each of the copyright holders list ed above has agreed that no person shall be  deemed to have infringed the copyright 
in the included material of any such copy right holder by reason of having used the specification set forth herein or having 
conformed any computer soft ware to the specification.
Subject to all of the terms and conditions below, the owners of  the copyright in this specification hereby grant you a fully-pa id 
up, non-exclusive, nontransferable, perpetual, worldwide license (w ithout the right to sublicense), to use this specification t o 
create and distribute software and special purpose specifications that are based upon this specification, and to use, copy, and  
distribute this specification as provided under the Copyright Ac t; provided that: (1) both the copyright notice identified abov e 
and this permission notice appear on any copies of this specification;  (2) the use of the specifications is for informational 
purposes and will not be copied or posted on any network comput er or broadcast in any media and will not be otherwise resold 
or transferred for commercial purposes; and (3) no modifications are made to this specification. This limited permission 
automatically terminates without notice if you breach any of these terms or conditions. Upon  termination, you will destroy 
immediately any copies of the specifica tions in your possession or control. 
PATENTS
The attention of adopters is directed to the possibility that compliance with or adoption of OM G specifications may require use  
of an invention covered by patent rights. OMG shall not be responsible for identifying patents for which a license may be 
required by any OMG specification, or for con ducting legal inquiries into the legal vali dity or scope of those patents that are  
brought to its attention. OMG specifications  are prospective and advisory only. Pros pective users are res ponsible for protectin g 
themselves against liability for infringement of patents.
                                                                                                                      
GENERAL USE RESTRICTIONS
Any unauthorized use of this specification may violate copyright  laws, trademark laws, and co mmunications regulations and 
statutes. This document contains information which is protected by copyright. All Rights Reserved. No part of this work covered by copyright herein may be reproduced or used in an y form or by any means--graph ic, electronic, or mechanical, 
including photocopying, recording, taping, or information stor age and retrieval systems--without permission of the copyright 
owner.
DISCLAIMER OF WARRANTY
WHILE THIS PUBLICATION IS BELIEVED TO BE A CCURATE, IT IS PROVIDED "AS IS" AND MAY CONTAIN 
ERRORS OR MISPRINTS. THE OBJECT MANAGEMENT GROUP AND THE COMPANIES LISTED ABOVE MAKE 
NO WARRANTY OF ANY KIND, EXPRES S OR IMPLIED, WITH REGARD TO  THIS PUBLICATION, INCLUDING 
BUT NOT LIMITED TO ANY WARRANTY OF TITL E OR OWNERSHIP, IMPLIED WARRANTY OF 
MERCHANTABILITY OR WARRANTY OF FITNESS FOR A PARTICULAR PURPOSE OR USE. IN NO EVENT SHALL THE OBJECT MANAGEMENT GROUP  OR ANY OF THE COMPANIES LISTED ABOVE BE 
LIABLE FOR ERRORS CONTAINE D HEREIN OR FOR DIRECT, IN DIRECT, INCIDENTAL, SPECIAL, 
CONSEQUENTIAL, RELIANCE OR COVER DAMAGES, INCL UDING LOSS OF PROFITS, REVENUE, DATA OR 
USE, INCURRED BY ANY USER OR ANY THIRD PARTY IN CONNECTION WITH THE FURNISHING, PERFORMANCE, OR USE OF THIS MATERIAL, EVEN IF  ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. 
The entire risk as to the quality and performance of software developed using this specification is borne by you. This 
disclaimer of warranty constitutes an essential part of the license granted to you to use this specification.
RESTRICTED RIGHTS LEGEND
Use, duplication or disclosure by the U.S. Government  is subject  to the restrictions set forth in subparagraph (c) (1) (ii) of  The 
Rights in Technical Data and Computer Software Clause at DFARS 252.227-7013 or in subparagraph (c)(1) and (2) of the 
Commercial Computer Software - Restricted Rights clauses at 48 C.F.R. 52.227-19 or as specified in 48 C.F.R. 227-7202-2 of 
the DoD F.A.R. Supplement and its successors, or as specified in 48 C.F.R. 12.212 of the Federal Acquisition Regulations and 
its successors, as applicable. The specification copyright owners  are as indicated above and may be contacted through the 
Object Management Group, 109 Highland Avenue, Needham, MA 02494, U.S.A.
TRADEMARKS
IMM®, MDA®, Model Driven Archit ecture®, UML®, UML Cube logo®, OMG Logo®, CORBA® and XMI® are 
registered trademarks of the Object Management Group, Inc., and Object Management Group™, OMG™ , Unified Modeling 
Language™, Model Driven Architectur e Logo™, Model Driven Architecture Di agram™, CORBA logos™, XMI Logo™, 
CWM™, CWM Logo™, IIOP™, MOF™, OMG Interface Definitio n Language (IDL)™ , and OMG SysML™ are trademarks 
of the Object Management Group. All other products or comp any names mentioned are used for identification purposes only, 
and may be trademarks of their respective owners.
COMPLIANCE
The copyright holders listed abov e acknowledge that the Object Management Gro up (acting itself or through its designees) is 
and shall at all times be the sole entity that may authorize developers, suppliers and sellers of computer software to use 
certification marks, trademarks or other sp ecial designations to  indicate compliance wi th these materials. Software developed 
under the terms of this license may clai m compliance or conformance with this sp ecification if and only if the software 
compliance is of a nature fully matching the applicable compliance points as stated in the specification. Software developed 
only partially matching the applicable compliance points may claim only that the software was based on this specification, but may not claim compliance or confor mance with this specification. In  the event that testing suites  are implemented or approved 
by Object Management Group, Inc., software developed usin g this specification may claim co mpliance or conformance with 
the specification only if the software satisfactorily completes the testing suites.
OMG’s Issue Reporting Procedure
All OMG specifications are subject to continuous review and impr ovement. As part of this process we encourage readers to 
report any ambiguities, inconsistencies, or inaccuracies they may fi nd by completing the Issue Reporting Form listed on the 
main web page http://www.omg.org , under Documents, Report a Bug/Issue (http://www.omg.org/report_issue.htm).
Semantics of Business Vocabula ry and Business Rules, v1.3 i       Table of Contents
Preface ................ .................. .................. .................. .................. .............xvii
Part I - Introduction ................ .................. .................. .................. ................. 1
1  Scope ....................... .................................... .............................. .................... 3
1.1  General ................. ................ ................ ................. ................ ................. ............... 3
1.2  Applicability ........... ................ ................ ................. ................ ................. ............... 3
1.3  SBVR Specification Fi les ............. ................ ................. .............. .............. ............. 3
1.4  Terminological Dictionarie s and Rulebooks ........... ................ ................. ............... 4
1.5  Usage of an SBVR C ontent Model ........ ................. ................ ................. ............... 4
1.6  For SBVR Tool Vendors ............... ................ ................. .............. .............. ............. 5
2  Conformance .. .................................... .................................... .......................... 5
2.1  General ................. ................ ................ ................. ................ ................. ............... 5
2.2  Types of conformance ......... .............. .............. .............. .............. .............. ............. 5
2.3  Conformance Claim Requi rement to Specify SBVR Conc epts Supported ............ 6
2.4  Terminological Dictionar y and/or Rulebook Interchange Conformance .. ............... 7
 2.4.1 General ................................................................................................................ .. 7
 2.4.2 Conformance of an SBVR Producer ...................................................................... 7
 2.4.3 Conformance of an SBVR Processor ..................................................................... 8
3  Normative Referen ces ....................... .................................... .......................... 9
4  Terms and Defini tions ........................ .................................... .......................... 9
5  Symbols ............... .................................... .............................. ........................ 10
6  Additional Information ...... .............................. .............................. .................. 10
6.1  How to Read this Specificati on .................. ................ ................. .............. ........... 10
 6.1.1 About the Annexes ............................................................................................... 11
 6.1.2 About the Normative S pecification ....................................................................... 12
6.2  Acknowledgements ............. .............. .............. .............. .............. .............. ........... 13
Part II - Terminological Dictionar y for Terminological Dictionaries  
and Rulebooks............... .................. ................ ................ .............. 15
7  Vocabulary Registration Vo cabulary .................... ........................ .................. 19
7.1  Vocabulary Registration Vocabul ary ................... .............. ............... ........... ......... 19
 7.1.1 Vocabularies Presented in this Document ........................................................... 19
 7.1.2 External Vocabularies and Namespaces ............................................................. 19
8  Linguistic Foundations ..... .............................. .............................. .................. 21
8.1  Things, Meanings, and Expressi ons ................... .............. ............... ........... ......... 21
ii               Semantics of Business Vocabulary and Business Rules, v1.3 8.1.1 Semiotic/Semantic Triang le in SBVR Term s ......................... ............................... 21
 8.1.2 SBVR Concepts for the Corners of the Semiotic/Semantic Triangle ................... 22
 8.1.3 SBVR Concepts for the Sides of the Semiotic/Semantic Triangle ....................... 23
8.2  Kinds of Thing ....... ................ ................ ................. ................ ................. ............. 23
8.3  Kinds of Meaning ..... ................ ................. ................ ................. ................ ........... 26
 8.3.1 Kinds of Meaning ................................................................................................. 26
 8.3.2 Kinds of Proposition ............................................................................................. 28
8.4  Kinds of Expression .......... ................. .............. .............. .............. .............. ........... 29
8.5  Connections between Concept s and Things in the Business ................. ............. 30
 8.5.1 Introduction .......................................................................................................... 3 0
 8.5.2 Extensions ............................................................................................................ 3 1
 8.5.3 Instances .............................................................................................................. 31
8.6  Connections between Kinds of Mean ing and States of Affairs in the  
 Business ................... ................. ................ ................ ................. .............. ........... 32
 8.6.1 Connections between Propositions and St ates of Affairs in the Business ........... 32
 8.6.2 Connections between Propositions and Actualities in the Business .................... 33 8.6.3 Connections between Elements of Guidance and States of Affairs in the  
     Business ............................................................................................................... 34
 8.6.4 Connections between Roles and the Things in the Business that Play Them ..... 35
8.7  Connections between Expressi ons and Things in the Busine ss ............. ............. 36
8.8  Necessities Concerning Extens ion ............... ................. .............. .............. ........... 37
9  Communities and Authorities  ................... .............................. ........................ 39
9.1  Communities and Subcommunities  ................. .............. .............. .............. ........... 39
 9.1.1 Community ........................................................................................................... 39
 9.1.2 Kinds of Community ............................................................................................. 40
9.2  Authorities ............. ................ ................ ................. ................ ................. ............. 41
10  Characteristics  ............................ .................................... .............................. 43
10.1  Introduction ........... ................ ................ ................. ................ ................. ............. 43
10.2  Characteristic ..... ................. .............. .............. .............. .............. .............. ........... 43
10.3  Kinds of Characterist ic ................... ................. .............. .............. .............. ........... 44
10.4  Concept Generalizat ion/Specialization ........ ................. .............. .............. ........... 45
11  Concepts ............ .................................... .............................. ........................ 47
11.1  Noun Concepts ....... ................ ................. ................ ................. ................ ........... 47
 11.1.1 Introduction ........................................................................................................ 47
 11.1.2 Noun Concept .................................................................................................... 47 11.1.3 General Noun Concepts ..................................................................................... 48
 11.1.4 Individual and Unitary Noun Concepts ............................................................... 49
11.2  Verb Concept s ............... ................ ................. .............. .............. .............. ........... 50
 11.2.1 Introduction ........................................................................................................ 50
 11.2.2 Verb Concept ..................................................................................................... 50 11.2.3 Verb Concept Role ............................................................................................. 51
 11.2.4 Verb Concepts and Propositions ........................................................................ 52
 11.2.5 Kinds of Verb Concept ....................................................................................... 52
Semantics of Business Vocabula ry and Business Rules, v1.3 iii       11.3  Reference Schemes ............. ................ ................. ................ ................. ............. 53
12  Representations .. .................................... .............................. ........................ 57
12.1  Representations ...... ................ ................. ................ ................. ................ ........... 57
 12.1.1 Representation ................................................................................................... 57
 12.1.2 Representation Formality ................................................................................... 58
 12.1.3 Representation Disambiguation ......................................................................... 59
12.2  Designations ........... ................ ................. ................ ................. ................ ........... 60
 12.2.1 Designation ........................................................................................................ 60
 12.2.2 Verbal and Nonverbal Designations ................................................................... 61 12.2.3 Designation Preferences .................................................................................... 63
 12.2.4 Placeholder and Verb Concept Role Designation .............................................. 64
12.3  Wordings for Verb C oncepts ............... .............. .............. .............. .............. ......... 65
 12.3.1 Verb Concept Wording ....................................................................................... 65
 12.3.2 Kinds of Verb Concept Wording ......................................................................... 67
12.4  Placeholders in Verb Concept Wordings ........ .............. .............. .............. ........... 69
12.5  Statements ............ ................ ................ ................. ................ ................. ............. 70
13  Concept Defini tion ...................... .................................... .............................. 73
13.1  Definitions ............. ................ ................ ................. ................ ................. ............. 7 3
13.2  Definitional Entr ies ................ ................ ................. ................ ................. ............. 75
14  Structures in Concept Syst ems ................................ .................................... 77
14.1  Structural Connections  between Things ......... .............. .............. .............. ........... 77
 14.1.1 Associations ....................................................................................................... 77
 14.1.2 Partitive Connections ......................................................................................... 79
14.2  Structural Connecti on between Concepts ....... .............. .............. .............. ........... 80
 14.2.1 Categorization .................................................................................................... 80
 14.2.2 Classification ...................................................................................................... 82
 14.2.3 Characterization ................................................................................................. 83
 14.2.4 Verb Concept Objectifications ............................................................................ 84
14.3  Contextualization .... ................ ................. ................ ................. ................ ........... 85
 14.3.1 Context of Thing ................................................................................................. 85
 14.3.2 Situations ........................................................................................................... 8 7
 14.3.3 Facets ................................................................................................................ 88
14.4  Elements of Co ncept System Structure ..... ................ ................. .............. ........... 90
14.5  Conceptualization Choices ............... .............. .............. .............. .............. ........... 91
15  Elementary Co ncepts ................. .................................... .............................. 93
15.1  Introduction ........... ................ ................ ................. ................ ................. ............. 93
15.2  Quantities .............. ................ ................ ................. ................ ................. ............. 9 3
15.3  Numbers ............... ................ ................ ................. ................ ................. ............. 94
15.4  Sets ............. ................. ................ .............. .............. .............. .............. .............. .. 94
16  Business Rules .............. .............................. .............................. .................. 97
16.1  Elements of Gui dance ................. ................ ................. .............. .............. ........... 97
 16.1.1 Introduction ........................................................................................................ 97
iv               Semantics of Business Vocabulary and Business Rules, v1.3 16.1.2 Business Rules and Advices .............................................................................. 98
 16.1.3 Elements of Governance .................................................................................. 100
16.2  Element of Guidanc e Statements ......... ................. ................ ................. ........... 100
16.3  Fundamental Principles fo r Elements of Guidance ........... ............... ........... ....... 102
 16.3.1 The Severability Principle ................................................................................. 102
 16.3.2 The Accommodation Principle ......................................................................... 103
 16.3.3 The Wholeness Principle ................................................................................. 103
16.4  Accommodations, Exceptions , and Authorizations ........... ............... ........... ....... 103
 16.4.1 Authorizations .................................................................................................. 103
 16.4.2 Exceptions ........................................................................................................ 104 16.4.3 Approaches to Capturing Accommodat ions, Exceptions, and Authorizations . 104
17  Definitional Gu idance ................. .............................. .................................. 109
17.1  Definitional Element s of Guidance ...... .............. .............. .............. .............. ....... 109
 17.1.1 Introduction ...................................................................................................... 109
 17.1.2 Definitional Rules ............................................................................................. 109 17.1.3 Definitional Advices .......................................................................................... 110
17.2  Definitional Elem ent of Guidance Statements .............. .............. .............. ......... 111
 17.2.1 Statements of Definitional Rules ...................................................................... 111
 17.2.2 Statements of Definitional Advices ................................................................... 113
17.3  Connections between  Definitional Rules and Concepts ... ............... ........... ....... 114
18  Behavioral Guid ance ........................ .................................... ...................... 117
18.1  Behavioral Elements of Guidance .............. ................ ................. .............. ......... 117
 18.1.1 Introduction ...................................................................................................... 117
 18.1.2 Behavioral Rules .............................................................................................. 117
 18.1.3 Business Rule Enforcement ............................................................................. 118
 18.1.4 Behavioral Advices ........................................................................................... 118
18.2  Behavioral Element of Guidance Statements ............... .............. .............. ......... 120
 18.2.1 Statements of Behavioral Rules ....................................................................... 120
 18.2.2 Statements of Behavioral Advices ................................................................... 122
19  Business Collections of Meanings and Represe ntations ........................... 125
19.1  Bodies of Meanings ................ ................. ................ ................. ................ ......... 125
 19.1.1 Bodies of Shared Meaning ............................................................................... 125
 19.1.2 Bodies of Shared Concepts ............................................................................. 126
 19.1.3 Bodies of Shared Guidance ............................................................................. 127
19.2  Sets of Business Representat ions ............. ................ ................. .............. ......... 127
 19.2.1 Business Vocabularies ..................................................................................... 127
 19.2.2 Speech Community Representation Sets ........................................................ 129
19.3  Ways of Packaging SBVR C ontent for Publication ........... ............... ........... ....... 130
 19.3.1 Terminological Dictionaries .............................................................................. 130
 19.3.2 Rulebooks ........................................................................................................ 131
19.4  Business Contents of a Comm unication ................ ................ ................. ........... 132
19.5  Namespaces ......... ................ ................ ................. ................ ................. ........... 133
 19.5.1 Namespace ...................................................................................................... 133
Semantics of Business Vocabula ry and Business Rules, v1.3 v        19.5.2 Vocabulary Namespaces ................................................................................. 134
 19.5.3 Attributive Namespaces ................................................................................... 135
20  Adoption ....... .................................... .................................... ...................... 137
20.1  Adoption of Definitions ........ .............. .............. .............. .............. .............. ......... 137
20.2  Adoption of Business Rules ................ .............. .............. .............. .............. ....... 138
21  Logical Formulation of Se mantics ...................... ........................ ................ 141
21.1  General ............ ................ ................. .............. .............. .............. .............. ......... 141
21.2  Semantic Formulations ....... .............. .............. .............. .............. .............. ......... 144
21.3  Logical Formulations ............... ................. ................ ................. ................ ......... 145
 21.3.1 Variables and Bindings .................................................................................... 146
 21.3.2 Atomic Formulations ........................................................................................ 150
 21.3.3 Instantiation Formulations ................................................................................ 151 21.3.4 Modal Formulations .......................................................................................... 152
 21.3.5 Logical Operations ........................................................................................... 155
 21.3.6 Quantifications ................................................................................................. 159 21.3.7 Objectifications ................................................................................................. 163 21.3.8 Projecting Formulations ................................................................................... 165
 21.3.9 Nominalizations of Propositions and Questions ............................................... 169
21.4  Projections ............ ................ ................ ................. ................ ................. ........... 173
22  Index of Vocabulary Entries (Informative) .......... ........................ ................ 181
Part III - Transformation to  XMI Metamodel and Metamodel’s  
 Interpretation in Formal Logics ............ .............. .............. ........... 191
23  SBVR’s Use of MOF and XMI ............................. ........................ ................ 193
23.1  General ............ ................ ................. .............. .............. .............. .............. ......... 193
23.2  SBVR's Use of MOF . ................. ................ ................ ................. .............. ......... 193
 23.2.1 Metamodels ...................................................................................................... 193
 23.2.2 SBVR Content Models ..................................................................................... 194
23.3  MOF Model Elements fo r SBVR .............. ................ ................. ................ ......... 195
 23.3.1 MOF Packages for SBVR Vocabulary Namespaces ........................................ 195
 23.3.2 MOF Classes for SBVR Noun Concepts .......................................................... 196 23.3.3 MOF Boolean Attributes for SBVR Characteristics .......................................... 197
 23.3.4 MOF Associations for SBVR Binary Verb Conc epts ........................................ 198
 23.3.5 MOF Attributes for SBVR Role s of Verb Concep ts ....................... ................... 199
 23.3.6 MOF Classes for SBVR Ternary Verb Concepts ............................................. 200
 23.3.7 Data Values ...................................................................................................... 201
 23.3.8 XMI Names ...................................................................................................... 202
23.4  Using MOF to Repres ent Semantics .............. .............. .............. .............. ......... 202
 23.4.1 Multiclassification ............................................................................................. 202
 23.4.2 Open World Assumption .................................................................................. 202
23.5  Example SBVR Conten t Model ............. ................. ................ ................. ........... 203
23.6  The SBVR Content Model for SBVR ................... .............. ............... ........... ....... 206
23.7  XMI for the SBVR  Model of SBVR ........... ................ ................. ................ ......... 207
vi               Semantics of Business Vocabulary and Business Rules, v1.3 23.7.1 XML Patterns for Vocabularies ........................................................................ 207
 23.7.2 XML Patterns for General Concepts ................................................................ 209
 23.7.3 XML Patterns for Individual Noun Concepts .................................................... 211
 23.7.4 XML Patterns for Verb Concepts ..................................................................... 211 23.7.5 XML Patterns for Sets of Elements of Guidance (Rule Sets) ........................... 213
 23.7.6 XML Patterns for Guidance Statements ........................................................... 214
24  Providing Semantic and Logical Foundations for Business Vocabulary  
      and Rules ....................... .............................. .............................. ................ 217
24.1  General .......... ................ ................ ................. .............. .............. .............. ......... 217
24.2  Logical Foundations  for SBVR ................... ................ ................. .............. ......... 217
 24.2.1 SBVR Formal Grounding Model Interpretation ................................................ 217
 24.2.2 Formal Logic & Mathematics in General .......................................................... 243
24.3  Formal Logic Interpretati on Placed on SBVR Terms ........ ............... ........... ....... 253
25  Supporting Documents ............... .............................. .................................. 265
25.1  General .......... ................ ................ ................. .............. .............. .............. ......... 265
25.2  SBVR XMI Metamodel ........ .............. .............. .............. .............. .............. ......... 265
25.3  SBVR XMI Metamodel XML Sc hema ............. .............. .............. .............. ......... 265
25.4  SBVR Content Model for SBVR ............... ................ ................. ................ ......... 265
Part IV - Annexes.......... .................... .................... .................... ................267
Annex A - SBVR Structured English .................... .................... ................269
Annex B - SBVR Structured English Patterns .. ................ .............. ..........289
Annex C - Use of UML Notation in a Business Context to Represent  
                 SBVR-Style Vocabularies ................ .............. .............. ...........299
Annex D - Additional References ................ ................ ................ .............307
Stand-alone Annexes
Annex E - Overview  of the Approach  
see http://www.omg.org/cgi-bin/doc?formal/15-05-09
Annex F - The Business Rules Approach  
see http://www.omg.org/cgi-bin/doc?formal/15-05-10
Annex G - EU-Rent Example  
see http://www.omg.org/cgi-bin/doc?formal/15-05-11
Annex H - The RuleSpeak® Business Rule Notation  
see http://www.omg.org/cgi-bin/doc?formal/15-05-12
Annex I -  Concept Diagram Graphic Notation  
see http://www.omg.org/cgi-bin/doc?formal/15-05-13
Semantics of Business Vocabula ry and Business Rules, v1.3 vii       Annex J - The ORM Notation for Verb alizing Facts and Business Rules  
see http://www.omg.org/cgi-bin/doc?formal/15-05-14
Annex K - Mappings and Relation ships to Other Initiatives  
see http://www.omg.org/cgi-bin/doc?formal/15-05-15
  Annex L - ORM Examples Related to the Logical Found ations for SBVR  
see http://www.omg.org/cgi-bin/doc?formal/15-05-16
Annex M - A Conceptual O verview of SBVR and the NIAM2007 Procedure to  
                  Specify a Conceptual Schema  
see http://www.omg.org/cgi-bin/doc?formal/15-05-17
viii               Semantics of Business Vocabulary and Business Rules, v1.3
Semantics of Business Vocabulary and Business Rules, v1.3     xviiPreface
About the Object Management Group
OMG
Founded in 1989, the Object Management Group, Inc. (OMG) is an open membership, not-for-profit computer industry 
standards consortium that produces and maintains computer industry specifications for in teroperable, portable and 
reusable enterprise applications in distributed, heter ogeneous environments. Membership includes Information 
Technology vendors, end users, government agencies and academia. 
OMG member companies write, adopt, and maintain its spec ifications following a matu re, open process. OMG's 
specifications implement the Model Driven Architecture® (MDA®), maximizing ROI through a full-lifecycle approach to 
enterprise integration that covers multiple operating sy stems, programming languages, middleware and networking 
infrastructures, and software development environments. OMG’s specifications include: UML® (Unified Modeling 
Language™); CORBA® (Common Object Request Broker Architecture); CWM™ (Common Warehouse Metamodel); 
and industry-specific standards for dozens of vertical markets.
More information on the OMG is available at  http://www.omg.org/ .
OMG Specifications
As noted, OMG specifications address middleware, modeling,  and vertical domain frameworks. A listing of all OMG 
Specifications is available from the OMG website at:
http://www.omg.org/spec
Specifications are organize d by the following categories:
Business Modeling Specifications
Middleware Specifications
• CO RBA/IIOP
•
Data Distribution Services
• Speciali
zed CORBA
IDL/Language Mapping SpecificationsModeling and Metadata Specifications
• UML, MOF, CWM, XMI
• UML 
Profile
Modernization Specifications
xviii                                                                                                       Semantics of Business Vocabul ary and Business Rules, v1.3Platform Independent Model (PIM), Platform Specific Model (PSM), Interface Specifications
• CORBAServices
• CORBAFacilities
CORBA Embedded Intelligence Specifications
CORBA Security SpecificationsOMG Domain SpecificationsSignal and Image Processing Specifications
All of OMG’s formal specifications may be downloaded w ithout charge from our website. (Products implementing OMG 
specifications are available from individua l suppliers.) Copies of specifications, available in PostScript and PDF format, 
may be obtained from the Specifications Catalog cited above or by contacting th e Object Management Group, Inc. at:
OMG Headquarters
109 Highland AvenueNeedham, MA 02494USATel: +1-781-444-0404Fax: +1-781-444-0320Email:  pubs@omg.org
Certain OMG specifications are also available as ISO standards. Please consult http://www.iso.org .
Issues
The reader is encouraged to report any technical or  editing issues/problems with this specification to http://www.omg.org/
report_issue.htm .
Semantics of Business Vocabulary and Business Rules, v1.3        1Part I - Introduction
This part includes Scope, Conformance, Normative Refe rences, Terms and Definitions, Symbols, and Additional 
Information.
2 Semantics of Business Vocabula ry and Business Rules, v1.3
Semantics of Business Vocabula ry and Business Rules, v1.3  31 Scope
1.1 General
This specification defines the vocabulary and rules (see Clauses 7 through 21) for documenting the semantics of business 
vocabularies and business rules for the exchange of busin ess vocabularies and business rules among organizations and 
between software tools.
This specification is interpretable in predicate logic with a small extension using modal operators. It supports linguistic 
analysis of text for business vocabularies and business rules, w ith the linguistic analysis itself being outside the scope of t his 
specification. 
1.2 Applicability
The SBVR specification is applicable to the domain of busin ess vocabularies and business rules of all kinds of business 
activities in all kinds of organizations. It provides an unamb iguous, meaning-centric, multilingual, and semantically rich 
capability for defining meanings of the language used by people in an industry, profession, discipline, field of study, or organization.  
This specification is conceptualized optim ally for business people rather than automa ted processing. It is designed to be 
used for business purposes, independent of information systems designs to serve these business purposes:
•Unambiguous definition of the meaning of business concepts  and business rules, consistently across all the term s,
nam
es and other representations used to express them, and across the natural languages in which those representati ons
are expressed, 
so that they are not easily misunderst ood either by “ordinary business people” or by lawyers.
•Expression of the meanings of concepts  and business rules in the wordings used by business people, who may belong
to different communities, so that each expression wording is uniquely as sociated with one mean ing in a given context.
•Transformation of the meanings of concepts and business rules as expressed by humans into forms that are suitable to
be processed
 by tools, and vice versa.
•Interpretation of the meanings of concepts and business rule s in order to discover inconsistencies and gaps within an
SBVR Content Model (see 2.4) using logic-based techniqu es.
•Application of the meanings of concepts and business rules to real-world business situations in order to  enable
rep
roducible decisions and to identify conformant and non-conformant business behavior.
•Exchange of the meanings of concepts  and business rules between humans and to ols as well as between tools withou t
lo
sing information about the essence of those meanings.
1.3 SBVR Specification Files
This specification provides that SBVR business vocabulary and busin ess rule content is exchanged among organizations 
and between software tools in “SBVR Content Model” file s (see 23.2.2). The full SBVR vocabulary and rules (see 
Clauses 7 through 21) for documenting the semantics of busines s vocabularies and business rules contained in the “SBVR 
Content Model for SBVR” file (see 23.2.1), which is an  example of an SBVR Content Model exchange document.
The MOF/XMI XML Schema for SBVR Content Model exchange documents (e.g., sub clau se 25.4) is the “SBVR XML 
Schema” file (see Clause 23 Intro and 25.3). This SBVR XML Sche ma is generated from the SBVR XMI Metamodel file 
based on transform rules in Clause 13 and the OMG XMI Specification. 
4                 Semantics of Business Vocabulary and Business Rules, v1.3This specification also provides an “SBVR XMI Metamodel” f ile (see sub clauses 23.1 and 25.2) that is generated from 
the content of Clauses 7 through 21 based on transform rules in Clause 23 and Annex A.
1.4 Terminological Dict ionaries and Rulebooks
The capability has two major areas of support:
• SBVR Terminological Dictionary: the business vocabulary pa rt of an SBVR Content Model. As with all kinds of 
dictionaries, it contains business data content that defi nes terms and other representations, including definitional 
business rules.   
 Dictionaries in general are not metamodels.  Dictionaries  have no metamodel levels.  All terms in a dictionary - 
including the terms that define the dictio nary content itself - are at the same leve l.  Dictionaries are easily and naturally 
extendable, as happens all the time in the culture.  This is also true for SBVR Content Models.
• SBVR Rulebook: an SBVR Content Model that includes behavioral guidance. It comprises an SBVR Terminological 
Dictionary and business data content that defines elem ents of guidance, including behavioral business rules.
An SBVR Content Model documents the meaning of terms and other representations that business authors intend when 
they use them in their business communications, as evidenced in their written documentation, such as contracts, product/
service specifications, and governance and regulatory compliance documents. Such documents are the authoritative 
source for the content of an SBVR Content Model.
1.5 Usage of an SBVR Content Model
Concepts in an SBVR Content Model can have as members in th eir extension only things that are in the real or planned 
world of the organization.  The extension of each of these c oncepts never contains anything in the SBVR Content Model.  
The terms and other representations in an SBVR Content Model name and describe the concepts.
SBVR Content Models focus exclusively on defining meaning and the expressions that represent meaning. They do not 
concern themselves with or cont ain assertions of the truth-value of propositio ns. Such concerns and assertions are outside 
the scope of SBVR and belong to the domain of data and rules enforcement. While putting business vocabulary in a 
published SBVR Business V ocabulary and bus iness rules in a published SBVR Rulebook is often used by organizations to 
communicate that, in fact, this vocabulary is the vocabulary in use and these rules ar e the rules in force, such assertions 
are outside the scope of the SBVR XMI metamodel. For exampl e, an organization could propose rules in a rulebook that 
are never put into force. SBVR Content Models therefore do not contain any kind  of business data except business 
vocabulary and business rules content.
While this specification contains the SBVR XMI Metamodel for interchanging th e documentation of business vocabulary 
and business rules content, th e SBVR XMI Metamodel is not a metamodel for any form of data m odel, message model, 
business information, or model designed for reasoning over business information.  A transformation is required to bridge 
from an SBVR Content Model to a data model, message model,  business information, model for reasoning over business 
information, or any other IT system model.
An SBVR Content Model provides all the business semantics need ed as input to such transf ormations by IT staff into 
information system designs, using a combination of decisi ons from system architects and Platform Independent Model 
designers together with software tool function.  By use of UR Is, SBVR Content Models can provide the business intent of any 
data element for which business vocabulary has been defined.
Semantics of Business Vocabula ry and Business Rules, v1.3        5In SBVR Content Models the key relationship is between meanings in the business vocabulary / rulebook and things in the 
world of the business; whereas in  IT systems the key relationship is between cl asses in the data/reasoning model and recorded 
business data in some form.
1.6 For SBVR Tool Vendors
The SBVR XMI Metamodel file is provided as part of this specification (see 25.2).
The SBVR XML Schema file is also provide d as part of this specification (see 25.3).
SBVR tools generate and process SBVR Content Model exchange documents that validate according to the “SBVR XML 
Schema” files of sub clause 25.3. The “SBVR Content Model for SBVR” file of sub clause 25.4 can be used as an 
example SBVR Content Model exchange document. 
The “SBVR XMI Metamodel” file of sub clause 25.2 is a ma chine-readable metamodel that may be employed in the 
development of SBVR tools.
2 Conformance
2.1 General
This specification defines conformance for software that im plements the specification and for an SBVR Content Model 
exchange document. Conformance of software is defined in terms of:
• the nature of its use of SBVR ( see sub clauses 2.2 and 2.4 ), and
• its support for SBVR concepts that ar e defined in clauses of this specification and implemented in the SBVR XMI 
Metamodel as specified in Clause 23 ( see sub clause 2.3 ).
2.2 Types of conformance
There are three distince types of conformance for this SB VR Specification. These are listed below. Unless otherwise 
stated, these types of conformance are independent.
1.Abstract syntax conformance . A tool demonstrating SBVR Abstract syntax  conformance provides a user interface, 
reports and/or an API that enables in stances of SBVR concepts that are im plemented in the SBVR XMI Metamodel 
to be created, read, updated, and deleted.  User interf aces and reports shall use the representations for these SBVR 
concepts as specified in Clauses 8 through 21, and APIs sh all use the representations for SBVR concepts as specified 
in Clauses 23 & 25.  The tool must also provide a way to validate the we ll-formedness of the content in SBVR 
Terminological Dictionaries and Rulebooks based on Definitions and Definitional Rules specified in the SBVR V ocabulary ( Clauses 8 through 21 ).
2.Terminological Dictionary and/or Rulebook interchange conformance . A tool demonstrating SBVR Terminological 
Dictionary and/or Rulebook interchange conformance can  import and export conformant SBVR Content Model 
Exchange Documents in SBVR XMI XSD-based XML files for all valid SBVR Terminological Dictionaries and 
Rulebooks ( see sub clause 2.4 for details ). Terminological Dictionary and/or Rulebook interchange conformance 
implies SBVR Abstract syntax conformance. A conforming SBVR  v1.3 tool shall be able to load and save XMI in the 
SBVR XMI XSD format ( sub clause 25.3 ). 
6                 Semantics of Business Vocabulary and Business Rules, v1.33.SBVR Semantics conformance . A tool demonstrating SBVR Semantics conf ormance provides a demonstrable way to 
interpret SBVR semantics, e.g., reasoning over SBVR Term inological Dictionary and/or Rulebook content to validate 
it, transformation of SBVR Terminological Dictionaries to UML Domain Logical Data Models or ODM/OWL 
Domain Reasoning Models, or transformation of SBVR Ru lebooks to executable rules. The normative specification 
for SBVR semantics includes Clauses 8 through 21, 23, & 24. SBVR Semantics conformance implies SBVR Abstract 
syntax conformance.
2.3 Conformance Claim Requirem ent to Specify SBVR Concepts  
Supported
For all types of conformance support fo r every SBVR concept that is impleme nted in the SBVR XMI Metamodel is 
optional. All claims of conformance must  specify which SBVR concepts are supported for each of the three types of 
conformance. With every claim of conformance, a table mu st be provided with this information in this format:
A software tool supports an SBVR concept if and only if all of the following hold:
• The software tool uses the representations specified  in SBVR for that concept  as specified under SBVR Abstract syntax 
conformance . It may use other representations of the same c oncept for other purposes, including other forms of 
exchange documents. 
• The software tool interprets the specifi ed representation of the concept as ha ving the meaning given by the Definition 
of that concept in this specification, and interprets instances of the concept in Terminological Dictionary and Rulebook content as having the associated characteristics.
• No Necessity concerning that concept that is given in this specification is violated by any Terminological Dictionary or Rulebook content maintained by the software tool nor in any SBVR Content Model exchange document the software tool produces. 
Note:  The requirement to interpret an instance as having the associ ated characteristics should not  be taken to mean that a 
conforming processor to use any elaborate reasoning to determine characteristics th at may be implied by the facts provided, 
even when those implications  are stated as Necessities in SBVR.  The intent of  the requirement is that what the tool does with 
the instance is consistent with the SBVR interpretation of the facts provided.
Use of Reference Schemes given in this sp ecification is recommended, but not required.
The Note, Example, and Dictionary Basis subentries of the SBVR vocabulary entries in this specification are purely 
informative. All other elements are to be understood as giving the meaning and requ ired characteristics of the concept. 
The vocabulary entry also specifies the representation of the conc ept that is used in this specification, while Clauses 23 
and 15 specify the representation of the concept in ex change documents conforming to this specification.SBVR Concept implemented Type of Conformance
in the SBVR XMI Metamodel Abstract syntax Terminological Dictionary 
and/or Rulebook 
interchangeSemantics
(show SBVR term, name, or 
verb concept wording for 
concept supported )show “Unser Interface” and/
or “Reports”, or “Not 
Supported”show “Producer” and/or 
“Processor”, or “Not 
Supported”name the supported 
demonstrable way(s) to 
interprets SBVR semantics
Semantics of Business Vocabula ry and Business Rules, v1.3  7Note:  A concept is a 
meaning.  Support for an SBVR concept is about using that meaning appropriat ely in the operation of 
the tool, and representing that meaning using the corresponding SB VR  representations in all types of conformance that are 
claimed, as specified under SBVR Abstract  syntax conformance. The internal designations and other representations for the 
meaning, and the representation of that meaning in other exchange documents are not c oncerns of this specification.
2.4 Terminological Dictionary and/or  Rulebook Interchange Conformance
2.4.1 General
This sub clause defines conformance for an SBVR Content Model exchange document, for software that produces SBVR 
Content Model exchange documents, and for software that processes SBVR Content Model exchange documents.
An exchange document that conforms to this specification (an “SBVR Content Model exchange document”) shall be an 
XML document that uses the SBVR  XMI XSD as its XML Schema ( see sub clause 25.3). The exchange document shall 
identify its document type as the XML Schemas specified in s ub clause 25.3 by using the URI for that schema specified 
in sub clause 25.4.
The content of the SBVR Content Model exchange document shall not contradict any Necessity in the SBVR Vocabulary 
(Clauses 8 through 21 ). However, no concept is closed in the SBVR XML Schema ( see sub clause 25.3 ). A conforming 
SBVR Content Model exchange do cument need not include all of the content in  a Terminological Dictionary or Rulebook. 
No Necessity should be interpreted as a requirement for inclus ion of any given fact in the SBVR Content Model exchange 
document. 
EXAMPLE
There is a rule that every statement expresses exactly one proposition. An SBVR Content Model exchange document that 
includes that a given statement expresse s two different propositions is not conformant. But a conforming document can 
include a statement without relating the statement to a propo sition, even though the proposition necessarily exists.  
Note:  If a use of SBVR for exchange between tools requires that cer tain kinds of facts be fully represented in the exchange 
document, the SBVR XML Schema can be extended for that purpose by adding the facts th at particular concepts are closed or 
particular verb concepts are internally closed ( see Clause 23 ).
An exchange document that conforms to this specification ma y include representations of instances of any SBVR concept 
that is included in the SBVR XMI Me tamodel as specified in Clause 23.
Note:  Not every conforming processor will support all of the concepts that can appear in a conforming SBVR document.  
Every conforming processor, however, is required to accept every conf orming document ( see sub clause 2.4.3 ).
For an XML exchange document that involves multiple namespaces,  conformance to this specification is only defined for 
that part of the exchange document that uses th e SBVR namespaces defined in this specification.
Note:  The document type of a conforming XML exchange document  need not be SBVR XML schema defined in sub clause 
25.3; but the document’s XML Schema sh all include the SBVR XML Schema as a subordinate namespace. Similarly, the 
SBVR XML Schema permits items like ‘definitions’ to ha ve formal representations defined by other XML Schemas.
2.4.2 Conformance of an SBVR Producer
A software tool that conforms as an SBVR producer shall produce exchange documents that conform to this specification 
as specified in 2.4.1.
8                 Semantics of Business Vocabulary and Business Rules, v1.3An SBVR producer may be able to produce representations of in stances of any concepts specified in Clause 21. An SBVR 
producer is not required to be able to produce a representa tion of instances of any specif ic concept defined in this 
specification.
For a conforming SBVR producer, a claim of conformance sh all identify the SBVR concepts for which it can produce 
representations of instances ( see sub clause 2.3 ). 
Note:  As indicated in 2.4.1, an SBVR producer may produce instances  of concepts not defined in SBVR as well.  In such a 
case, the SBVR fact model would be onl y a part of the exchange document.
An SBVR producer shall support (as defined in 2.3) all of the SBVR concepts for which it make s a claim of conformance.  
An SBVR producer shall not convey in the exchange document the intent of an SBVR concept by using a representation 
that is not specified herein.
2.4.3 Conformance of an SBVR Processor
A software tool that conforms as an SBVR processor sh all accept any exchange document that conforms to this 
specification as specified in 2.4.2. The interpretation it makes of any fact contai ned in the exchange document depends on 
whether the software tool supports the c oncepts associated with that fact ( see below ).
Note:  Accepting a valid exchange document is distinguished from re jecting the document as not processable and using none 
of the information in it. A tool can accep t a document and nonetheless discard much of  the information in it. Accepting is also  
distinguished from supporting instances of concepts found in th e exchange document, which refers  to interpreting all facts abou t 
instances of the concept properly into the internal models and functions of the tool ( see sub clause 2.3 ). 
Every SBVR processor shall be able to ac cept representations of facts about inst ances of all SBVR concepts for which a 
conformance claim of support is made. Ever y SBVR processor shall be able to a ccept the SBVR Content Model exchange 
documents listed in sub clause 25.4.
Note:  Depending on what the SBVR processor actually does with the SBVR Content Model exchange document, there may 
be SBVR concepts for which there is no valid use in the function of the tool ( see sub clause 2.3 ). For example, a tool that 
converts an SBVR Content Model exchange document to some other modeling language or rules language may find that there are SBVR concepts that have no image in the target language. In such a case, the proper support for the SBVR concept may be 
to do nothing with it.
When an SBVR processor encounters a representation of an in stance of a concept for whic h conformance is not claimed 
(including concepts that are not SBVR concepts), th e processor may choose to do any of the following:
• ignore the instance; 
• support the instance, and the SBVR concept it instantiates; 
• interpret the instance via internal concep ts that are not SBVR concepts per se.
An SBVR processor may, but need not, provide a warning when  it encounters a representation of an instance it does not 
support.
Semantics of Business Vocabula ry and Business Rules, v1.3        93 Normative References
The following normative documents contain provisions which, throug h reference in this text, cons titute provisions of this 
specification. For dated references, subse quent amendments to, or revisions of, an y of these publications do not apply.
• Berners-Lee, T., R. Fielding, L. Masinter. IETF RFC 2396: Uniform Resource Identifiers (URI): Generic Syntax, 
August 1998.
• International Organization for Standardization (ISO) : ISO 639-2. Codes for the Representation of Names of 
Languages, Part 2 : Alpha-3 Code. Library of Congress, 2002.
• International Organization for St andardization (ISO) : 1087-1. Terminology work — Vocabulary — Part 1: Theory and 
Application
• Meta Object Facility (MOF ) Core Specification, v2.0  
(http://www.omg.org/docs/formal/06-01-01.pdf).
• MOF 2.0/XMI Mapping Specification, v2.1   
(http://www.omg.org/docs/formal/05-09-01.pdf).
• International Organization for Standardization (ISO) : ISO 6093.  Information processing - Representation of 
numerical values in character strings for information interchange .  1985.
• OMG UML 2 Infrastructure, v2.1.1  
 (http://www.omg.org/docs/formal/07-02-04.pdf).
• The Cambridge Dictionary of Philosophy , 2nd ed. Cambridge University Press, 1999.
• The New Oxford Dictionary of English .
• The Oxford Dictionary of English .
• Unicode 4.0.0 specification : Glossary (http://www.unicode.org/versions/Unicode4.0.0/b1.pdf).
4 Terms and Definitions
For the purposes of this speci fication, the terms and definitions given in the normative reference and the following apply.
SBVR
shorthand for Semantics of Busine ss V ocabulary and Business Rules
SBVR Vocabularies
vocabularies that make up SBVR itself, for talk ing about semantics, vocabulary, and rules                         
Business Vocabulary
vocabulary that is under business jurisdiction
Business Rule
rule that is under business jurisdiction
10                 Semantics of Business Vocabulary and Business Rules, v1.3Business Vocabulary+Rules
business vocabulary plus a set of  business rules specified in terms of that business vocabulary
SBVR XMI Metamodel
MOF model generated from some of the terminological entries in SBVR Clauses 7 through 21 as specified in Clause 23
Terminological Dictionary
collection of representations including at least one designation or definition of each  of a set of concepts from one or more 
specific subject fields, together with other specifications of those concepts
Vocabulary
set of designations (such as terms and names) and verb concept wordings prima rily drawn from a single language to 
express concepts within a body of shared meanings
note that this specification does not use the word “vocabulary” to  refer to a dictionary or to any other sort of collection of 
terminological data
5 Symbols
FL    The indicated term is to be interpreted in formal logic.  Terms without this symbol are not interpreted in formal logic.
Figures in Clauses 8 through 21 depict the SBVR XMI Metam odel using notational conventions described in Clause 23. 
For the purpose of visualizing vocabularies, Annex C describe s a non-normative interpretation of those same figures and 
of figures in Annex G. Other non-normative notations used in  Clauses 7 through 21 are ex plained in Annexes A and H. 
6 Additional Information
6.1 How to Read this Specification
This specification describes a vocabulary, or actually a set of vocabularies, using terminological entries. Each entry 
includes a definition, along with other specifications such as notes and examples. Often,  the entries include rules 
(necessities) about the particular item being defined.
The sequencing of the clauses in this speci fication reflects the inherent logical or der of the subject matter itself. Later  
clauses build semantically on the earlier ones. The initial cl auses are therefore rather ‘deep’ in terms of SBVR’s 
grounding in formal logics and linguistics. Only after these clau ses are presented do clauses more relevant to day-to-day 
business communication a nd business rules emerge.
This overall form of presentation, essentia l for a vocabulary standard, unfortunately means the material is rather difficult 
to approach. A figure presented for each sub-vocabulary does help illustrate its structure; however, no continuous 
'narrative' or explan ation is appropriate.
6.1.1 About the Annexes
For that reason, the first-time general reader is urged to st art with some of the non-normative Annexes, which do provide 
full explanation of the material, as well as context and purpose. 
Semantics of Business Vocabula ry and Business Rules, v1.3        11• Annex E, Overview of the Approach, is strongly recommended in that regard. It provides a general introduction to the 
fundamental concepts and approach of SBVR.
• Annex F, The Business Rules Approach, explains the core ideas and principles  of business rules, which underpin 
SBVR’s origin and focus. This short Annex is strongly r ecommended for readers who are unfamiliar with this area. 
Good preparation for reading the specification is becoming fami liar with the notation (non-normative) used to present the 
entries.
• Annex A, SBVR Structured English, provides comprehensive explana tion in that regard.
• Annex B, SBVR Structured English Patterns, explains how to verbalize terminological entries.
General practitioners will find the followi ng sections of significant interest.
• Annex G, EU-Rent Example, provides a comprehensive case study, with a robust vocabulary and set of business rules 
fully worked through. Examples from EU-Rent are used widely in both the specification and Annexes to provide on-going commonality.
• Annex H, The RuleSpeakR Business Rule Notation, presents a widely-u sed, business-friendly syntax for expressing 
business rules.
• Annex I, Concept Diagram Graphic Notation, offers sugge stions for how an SBVR vocabulary can be diagrammed.
• Annex C, Use of UML Notation in a Business Context to Repres ent SBVR-style V ocabularies, is of special interest to 
practitioners familiar with UML diagramming.
Object-Role Modeling (ORM)-related Annexes: 
• Annex J, The ORM Notation for Verbalizing Facts and Busine ss Rules, provides an introduction to the ORM approach. 
ORM contributes heavily to the theoretical  underpinnings of SBVR, and represents some of the best practices in fact-
based vocabulary and rule development.
• Annex L, ORM Examples Related to the Logical Foundations  for SBVR, provides supplemental ORM material further 
clarifying the normative material, Logical Foundations for SBVR.
For those specialists and resear chers interested in standards and/or in th e formal logics underpinning of SBVR, the 
following material is of special interest.
• Annex K, Mappings and Relationships to Other Initiatives,  addresses where and how SBVR fits with other software 
and standards initiatives.
For practitioners interested in a methodology supporting SBVR, used  productively in industry for over 30 years, the fact-
oriented approach NIAM2007 offers interesting advice.
• Annex M - a Conceptual Overview of  SBVR and the NIAM2007 Procedure to Specify a Conceptual Schema.
• Annex D, Additional References, provides supplemental sources relevant to the formal underpinnings of SBVR.
NOTE: The SBVR Annexes in the table below are now published as stand-alone documents at the URIs shown solely for 
convenience and ease of use. The fact that they are publis hed as separate SBVR specif ication documents makes no 
change to their status as part of the SBVR specification,  or the way in which they can be updated under OMG Policies 
and Procedures.
12                 Semantics of Business Vocabulary and Business Rules, v1.3 
6.1.2 About the Norm ative Specification
The rest of this document contains the technical content of this specification.
Clauses 7 through 21 contain the SBVR terminological entries or ganized in focused topics that cover the subject filed of 
this specification: business vocabularie s and business rules. Clauses 7 through 25 provide the foundation for the SBVR 
XMI Metamodel which is generated from Clauses 7 through 21 based on the tran sformation specified in Clause 23. 
Clause 7, the Vocabulary Registration Vocabulary , provides names and definitions for th e vocabularies presented in the 
SBVR specification and of other vocabularie s referenced by the SBVR specification. 
As background for this specification, all readers are encouraged to first read Cl ause 8, which introduces the Semiotic/
Semantic Triangle.  It is the theoretic basis for the rest of the specification. 
Clauses 8 through 21 provide the terminological entries that comprise the SBVR Vocabulary . Parts of this vocabulary are 
intended for business people for use in business to communicate about:
• Business vocabularies, especially in Clauses 9 through 17 and 19 to 20.
• Business rules, especially in Clauses 16 through 20.
Clause 21 provides the terminological entries for the way that SB VR formulates the semantics of definitions and rules. It 
is not a vocabulary for business people but, rather, for those w ho work with the detailed specification of the meaning of 
business words and statements. 
Clause 22 is an index of terminological entries in Clauses 8 through 21. Clause 23 specifies how the SBVR XMI Metamodel is  generated from the terminological entries in the 
SBVR Vocabulary  
and the Vocabulary Registration Vocabulary  (Clauses 7 through 21). 
Clause 24 presents the formal logics  and mathematical underpinnings of th e SBVR XML Metamodel. A concept in 
Clauses 8 through 21 marked with the symbol ‘FL’ is  mapped to a formal logics concept in Clause 24.
Clause 25 lists supporting documents, such as an SBVR XM I-based XML schema (XSD) for the SBVR XMI Metamodel.Annex Document number URI
E - Overview of the Approach formal/2015-05-09 http://www.omg.org/cgi- bin/doc?formal/15-05-09
F - The Business Rules Approach formal/2015-05-10 http://www.omg.org/cgi- bin/doc?formal/15-05-10
G - EU-Rent Example formal/2015-05-11 http:/ /www.omg.org/cgi-bin/doc?formal/15-05-11
H - The RuleSpeak® Business Rule Notation formal/2015-05-12 http ://www.omg.org/cgi-bin/doc?formal/15-05-12
I - Concept Diagram Graphic Notation formal/2015-05- 13 http://www.omg.org/cgi- bin/doc?formal/15-05-13
J - The ORM Notation for Verbalizing Facts and  
Business Rulesformal/2015-05-14 http://www.omg.or g/cgi-bin/doc?formal/15-05-14
K - Mappings and Relationships to Other Initiatives for mal/2015-05-15 http:// www.omg.org/cgi-bin/ doc?formal/15-05-15
L - ORM Examples Related to the Logical  
Foundations for SBVRformal/2015-05-16 http://www.omg.or g/cgi-bin/doc?formal/15-05-16
M - A Conceptual Overview of SBVR and the 
NIAM2007 Procedure to Specify a Conceptual  
Schemaformal/2015-05-17 http://www.omg.or g/cgi-bin/doc?formal/15-05-17
Semantics of Business Vocabula ry and Business Rules, v1.3        13Clauses 7 through 21 use SBVR Structured English to express the SBVR terminological entr ies. Annex A describes how 
the Structured English is interpreted such that SBVR is specified in terms of itself.
Much of the material in Parts II and III is illustra ted by examples in the annexes, especially Annex G.
The clauses in this specification are organized in a logical manner and can be read sequentially. Short, highly-descriptive 
headings have been chosen with a focus on the essential subject matter, rather than on mechanics or underlying 
assumptions. The goal is to keep the topics as  reader-friendly and unbi ased as possible.  
However, this is a reference specificati on and, as such, is also structured to support reading in a non-sequential manner. 
Consequently, extensive cross-references are provided to facilitate browsing and search.
6.2 Acknowledgements
The following companies submitted and/or supported parts of this specification:
• Adaptive
• Automated Reasoning Corporation
• Business Rule Solutions, LLC
• Business Rules Group
• Business Semantics Ltd
• Fujitsu Ltd
• Hendryx & Associates
• Hewlett-Packard Company
• InConcept
• LibRT
• KnowGravity Inc
• MEGA
• Model Systems
• Neumont University
• Perpetual Data Systems
• PNA Group
• Sandia National Laboratories
• The Rule Markup Initiative
• Unisys Corporation
• X-Change Technologies Group
14                 Semantics of Business Vocabulary and Business Rules, v1.3
                                                                                             
Semantics of Business Vocabulary and Business Rules, v1.3  15Part II - Terminological Di ctionary for Terminological  
Dictionaries and Rulebooks
This part contains the SBVR terminological entries that ar e the foundation for the SBVR XMI Metamodel. The clauses of 
Part II address focused topics that ar e of interest to different audiences.
Clause 7, the Vocabulary Registration Vocabulary , provides names and definitions for the vocabularies presented in the SBVR 
specification and of other vocabularies refe renced by the SBVR specification.  Clau se 8 introduces th e Semiotic/Semantic 
Triangle. It is the theoretic basis for the rest of the specification. 
Clauses 8 through 21 provide the terminological entries that comprise the SBVR Vocabulary . Parts of this vocabulary are 
intended for business people for use in business to communicate about:
• Business vocabularies, especially in Clauses 9 through 17 and 19 and 20.
• Business rules, especially in Clauses 16 through 20.
Clause 21 provides the terminological entries for the way that SBVR formulates the semantics of definitions and rules. It 
is not a vocabulary for business people but, rather, for those who work with the detailed specification of the meaning of 
business words and statements. 
Clause 22 is an index of terminological entries in Clauses 8 through 21. Part II uses SBVR Structured English to express the SBVR te rminological entries. Annex A describes how the Structured 
English is interpreted such that SBVR is specified in terms of  itself. Although the Structured English is non-normative, its 
use in Clauses 7 through 21 has a normative interpretation descri bed in sub-clause 23.6. Examples are in natural language 
and use no particular notation except where noted.
Much of the material in Part II is illustrated by examples in the annexes, especially Annex G ..The primary subjects of the SBVR Vocabulary
 fit between two other relevant subject areas described below.
1.Expression  – things used to communicate (e.g., sounds, text, diagrams, gestures), but apart from their meaning — 
one expression can have many meanings.
2.Representation  – the connection between expression and a meaning.  Each representation ties one expression to one 
meaning.
3.Meaning  – what is meant by a word (a concept) or by a statement (a proposition) – how we think about things.
4.Extension  – the things to which meanings refer, which can be anything (even expressions, representations, and 
meanings when they are the subjects of our discourse).
16  Semantics of Business Vocabula ry and Business Rules, v1.3Following are exampl es of how some things, like “dri ver,” cross through each subject area.
Another subject area of this vo cabulary is reference schemes, which are ways people use information about something to 
identify it.  For example, a city in the United States is identif ied by a name combined with the state it is in.  The state is 
identified by its name or by a two-letter state code.
Representations provide a reference scheme  for concepts and propositions because  they are always tied to exactly one 
expression and to exactly one meaning.  On the other hand, a single expression can have mu ltiple meanings, a concept can 
have multiple expressions, a thing can be an instance of many concepts, and a proposition can be meant by many equivalent expressions.
A single representation can be tied to many speech acts, or to a single sp eech act, depending on how its expression is 
identified.  For example, if th e expression is a text or a sequence of words in dependent of any particular act of writing or 
speaking, the representation is independent in the same way.  Conversely, if the expression is identified as belonging to a 
specific speech act, then the representa tion is tied to that speech act also.Extension Meaning Representation Expression
The actual drivers of 
motor vehiclesConcept ‘driver’ — how we 
think of drivers, what characterizes themDesignation of the concept 
‘driver’ by the signifier “driver”The character sequence 
“driver”
Definition of the concept 
‘driver’ as “operator of a motor vehicle”The character sequence 
“operator of a motor vehicle”
The actual City of 
Los Angeles, California – a real placeIndividual noun concept ‘Los 
Angeles’ — how we think of that city, what distinguishes it from other places‘Los Angeles’ as a designation 
for the individual noun concept of ‘Los Angeles’ The character sequence “Los 
Angeles”
For each car that is 
out of service, its actually being out of serviceCharacteristic applicable to a car, 
what is meant by a car being out of serviceVerb concept wording ‘car
 is 
out of service’ as a template for the characteristic with ‘car
’ 
being a placeholderThe text “car  is out of 
service”
The actual state of 
affairs of it being obligatory in the EU-Rent business that it not rent to a barred driverProposition — the meaning of 
the statement “EU-Rent must not rent to a barred driver”The statement, “EU-Rent must 
not rent to a barred driver,” having the proposition as its meaningThe character sequence 
“EU-Rent must not rent to a barred driver”
Semantics of Business Vocabulary and Business Rules, v1.3        17Note : in the glossary entries below, the words “Concept Type: role” indicate that a general concep t being defined is a role.  
Because it is a general concept, it  is necessarily a situational role and is not a verb concept role.
__________________________________________________
SBVR Vocabulary
Language:  English
___________________________________________________
18  Semantics of Business Vocabula ry and Business Rules, v1.3
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      197 Vocabulary Registration Vocabulary
7.1 Vocabulary Registration Vocabulary
This sub clause gives names of vocabularies and namespaces.  Each  one is either provided by SB VR or is external to SBVR 
but formally referenced.
__________________________________________________
Vocabulary Registration Vocabulary
Language: English  
___________________________________________________
7.1.1 Vocabularies Present ed in this Document 
SBVR Vocabulary
Definition: the vocabulary  that is defined in SBVR Clauses 8 through 21
Formal Logic and Mathematics Vocabulary
General Concept: vocabulary
Note: See Clause 24 - Providing Semantic and Logical Foundations for Business Vocabulary and 
Rules.
Vocabulary Registration Vocabulary
General Concept: vocabulary
Note: This clause.
7.1.2 External Vocabul aries and Namespaces 
ISO 1087-1 (English)
Definition: the vocabulary  for the English language specified in [ISO1087-1]
ISO 6093 Number Namespace
Definition: the namespace  of designations  of decimal numbers specified in [ISO6093]
Namespace URI: urn:iso: std:iso:6093:clause:8
ISO 639-2 (English)
Definition: the vocabulary  of English language names of languages specified in [ISO639-2] available at 
http://www.loc.gov/standards/iso639-2/englangn.html
Namespace URI: http://www.loc.gov/standards/iso639-2/php/English_list.php
20                                                                                                       Semantics of Business Vocabula ry and Business Rules, v1.3ISO 639-2 (Alpha-3 Code)
Definition: the vocabulary  of 3-letter codes for languages specified in [ISO639-2] available at  
http://www.loc.gov/standards/iso639-2/langcodes.html
Namespace URI: http://www.loc.gov/standards/iso639-2/php/code_list.php
UML 2 Infrastructure
Definition: the namespace  of designations  for UML 2 Infrastructure concepts as defined by 
[UML2infr].
Unicode Glossary
Definition: the vocabulary  presented in [Unicode4]. 
Uniform Resource Identifiers Vocabulary
Definition: the vocabulary  presented in [IETF RFC 2396]. 
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                     218 Linguistic Foundations
8.1 Things, Meanings, and Expressions
8.1.1 Semiotic/Semantic Triangle in SBVR Terms
This sub clause introduces the c oncepts that comprise one leg, ‘ meaning  corresponds to  thing ’, of the Semiotic/Semantic 
Triangle which was first introduced by Charles Sanders Peirce at the beginning of the twentieth century and later by (Ogden 
and Richards 1923).  See “Ontology, Metadata, and Semiotics” [Sowa].
Figure 8.1 - Semiotic/Semantic Triangle in SBVR Terms
This diagram shows the SBVR XMI Metamodel and SBVR vocabular y by two different interpretations. See Clause 13 and Annex C.
The Semiotic/Semantic Triangle is the theoretic basis for SB VR’s linguistics-based architecture in general and for the 
fundamental separation of representation (expression) from me anings in SBVR’s architecture. Being a linguisitic-based 
standard the instances of concepts are the things in the universe of discourse, i.e. , the world of the organization that uses t he 
SBVR Business V ocabulary, and not concepts in the SBVR model.

22                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.3Figure 8.2 - Relating SBVR Concepts  to the Semiotic/Semantic Triangle
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by two different inte rpretations. See Clause 13 and Annex C.
8.1.2 SBVR Concepts for the Corner s of the Semiotic/Semantic Triangle
meaning
Definition: what is meant by a word, sign, statement ( natural language meaning ), or description ; what 
someone intends to express or what someone understands
thing  FL
Source: ISO 1087-1 (English)  (3.1.1) [‘object ’]
Definition: anything perceivable or conceivableNote: Every other concept
 implicitly specializes the concept  ‘thing ’.
Reference Scheme: an individual noun concept  that corresponds to  the thing
expression
Definition: something that expresses or communicates, but considered independently of its interpretation
Example: the sequence of characters “car”Example: the sequence of speech  sounds (t), (r), and (e
)
Example: a smileExample: a diagramExample: The entire text of a book

Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                     238.1.3 SBVR Concepts for the Sides of the Semiotic/Semantic Triangle
 meaning  corresponds to  thing
Definition: the thing  is conceptualized by and is consistent with the meaning
Note: A concept corresponds to each instance of the concept. A propos ition corresponds to a state of 
affairs (which might or might not be actual). A proposition that is true corresponds to an 
actuality.
Note: For some kinds of meanings this is a many-to -many relationship. For others it is many-to-one.
expression  represents  meaning
Definition: the expression  portrays or signifies the meaning
8.2 Kinds of Thing
Figure 8.3 - Kinds of Thing
This diagram shows the SBVR XMI Metamodel and SBVR vocabular y by two different interpretations. See Clause 13 and Annex C.
res
Definition: thing  that  is not a  meaning  

24                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.3thing1 is thing2 FL
Definition: the thing1 and the  thing2 are the same thing
property
Definition: quality or trait actually belonging to a thing  itself
Dictionary Basis: a quality or trait belonging to a person or thing [MWUD property]
Example: Consider three st atements: “Meeting 1 starts at 1PM”, “Meeting 2 starts at 2PM”, “Meeting 1 
ends at 2PM”.  These describe three distinguisha ble properties: starting at 1PM, ending at 2PM 
and starting at 2PM.  Each ‘property’ should not be confused with the ve rb concept role of the 
respective property association (which roles could be labeled “starting time” or “ending 
time”), because starting at 1PM is a differen t property than starti ng at 2PM. Also, the 
‘property’ is not the thing that  fills role (it’s not 1PM or 2P M), because starting at 2PM is a 
different property than ending at 2PM.
Example: Example: car group has daily price for member  affiliation. This example involves a ternary 
property association, rather than a binary  one. (Examples of “member affiliation” might 
include AARP membership, AAA membership, Costco membership, etc.)
Note: By “actually” we mean “in the universe of disc ourse” (the things that we are talking about), not 
in a model of the universe of discourse. This meaning of “property” should not be confused with the meaning of “property” in an IT modeling context.  There is no 1:1 relationship between “property association” in SBVR and “at tribute” or “property” in a class or entity 
model.
state of affairs  FL
Definition: event, activity, situation , or circumstance
Reference Scheme: a proposition  that corresponds to  the state of affairs
Reference Scheme: an individual noun concept  that corresponds to  the state of affairs
Necessity: No state of affairs  is a proposition
Note: Any representation of a proposition may be us ed to denote the state(s) of affairs that it 
corresponds to. A proposition statement serves as a definite description for the state of affairs that the proposition corresponds to. 
Note: Some general noun concepts have extensions that are states of affa irs; for example, the 
extension of ‘car being damaged during rental; is  the states of affairs of rented cars being 
returned from rental damaged. A given state of affairs of this kind can be referenced by an 
individual noun concept (based on the general noun concept) such as ‘the car referenced by VIN xxxxx being damaged during the rental referenced by contract number yyyyyy’.
Note: A state of affairs
 can be possible or impossible.  Some of  the possible ones are actualities.  A   
proposition  corresponds to  a state of affairs . A state of affairs  either occurs or does not 
occur, whereas a proposition  is either true or false. A state of  affairs is not a meaning. It is a 
thing that exists and can be  an instance of a concept, even if it does not happen. 
Example: EU-Rent owning 10,000 rental cars is a stat e of affairs to which the proposition “EU-Rent 
owns 10,000 rental cars”, corresponds.
Example: It being obligatory that each rental have at mo st three additional drivers is a state of affairs to 
which the rule, “Each rental must have at most three additional drivers”, corresponds.
state of affairs  is actual  FL
Definition: the state of affairs  happens (i.e., takes place, obtains)
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                     25Note: The meaning of ‘is actual’ should not be confused with logical existence, which just means 
being something that is of interest in the unive rse of discourse. A potential state of affairs can 
‘exist’ as a ‘thing’ in the universe of discourse and thereby be involved in relationships to other 
things (e.g., plans, desires, fear s, expectations, perceptions, etc.) ev en if it is not actual, even if 
it never happens. A plan for, desire for, fear of, etc. a state of affairs is  a different thing in the 
universe of discourse from the state of affairs its elf that is planned for, desired or feared. The 
plan, desire fear, etc. can move between being act ual and not actual. The state of affairs that is 
planned, desired or feared is corresponded to  by a different proposition; it can, independently 
of the plan, desire or fear, also move between being actual and not actual.
Note: If a state of affairs is perceivable ( real) in a possible world, it is actual. If it is only conceivable 
(planned, talked about ) and not perceivable in a possible world, it is not actual.
Example: “The EU-Rent London-Heathrow Branch wants to be profitable”. Even  when that branch is 
unprofitable, the previous stat ement can correspond to an actua lity that involves the desired 
state of affairs that the EU-Rent London-Heathrow  Branch is profitable. The desired state of 
affairs exists as an object of desire and planni ng regardless of whether there is ever an actual 
state of profitability. It exists and is involved in an actuality (an instance of the verb concept ‘company wants state of affairs’) even when th e branch is unprofitab le. The nature of the 
desired state of affairs is that it is a ‘desired  state of affairs’ - conceived but not perceived.  
The actual state of affairs that the EU-Rent London-Heathrow Branch  is profitable exists only 
when the branch is profitable.  The nature of the actu al state of affairs, if it exists, is that it is a 
happening in the world. It is per ceived, as well as being conceived.
actuality  FL
Definition: state of affairs  that is actual
Note: Actualities are states of affair s that actually happen, as  distinct from states of affairs that don’t 
happen but nevertheless exist as subjects of discourse and can be imagined or planned.
Example: Consider two unitary noun concepts, the first defined as “ state of affairs ” that EU-Rent 
London-Heathrow Branch is profitab le” and the second defined as “ actuality ” that EU-Rent 
London-Heathrow Branch is profitable. The two definitions use the same objectification. The 
first concept always has an instance, regardless  of profitability. The second concept has an 
instance (the same instance) only  if the branch is profitable.
26                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.38.3 Kinds of Meaning
8.3.1 Kinds of Meaning
Figure 8.4 - Kinds of Meaning
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by two different inte rpretations. See Clause 13 and Annex C.
concept FL
Source: ISO 1087-1 (English)  (3.2.1) [‘concept ’]
Definition: unit of knowledge created by a unique combination of characteristics
General Concept: meaning
Reference Scheme: a designation  of the concept
proposition  FL
Definition: meaning  of a declarative sentence that is not a pa radox and that is invariant through all the 
paraphrases and translations of the sentence including synonymous closed logical  
formulations
Note: A wff is a special case of statement in which there are no free occurrences  of any variable, i.e., 
either it has constants in place of variable s, or its variables are bound, or both. 

Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                     27Source: [SubeGFOL]: proposition (2 & 3), Wff, Closed Wff
Necessity: It is necessary that each  proposition  that is created by binding all the verb concept roles  
of a given  verb concept  means what the definition  of the verb concept  defines it to mean.
Note: A verb concept role is played by a thing in the domain of discourse - the world of interest. A 
verb concept is ‘bound’ by specifying the th ing(s) that play th e verb concept role. 
Linguistically those things can be specified by a quantified noun phrase or by an individual noun concept or an expression or a pr onoun that refers to a specific thing.
Note: A proposition is always either true or fals e with respect to a possible world regardless of 
whether its truth value is known or is of interest.
Note: Sub clause 21.3, Logical Formulations, descri bes one of the ways to understand the logical 
structure of propositions, including how concepts, such as individual noun concepts, general concepts, verb concepts and role s, fit into that structure. 
Note: The word “proposition” has two common meanings: first, a statement that affirms or denies 
something, and second, the meaning of  such a statement. The concept ‘ proposition
’ is here 
defined in the second sense and should not be confused with the statement of a proposition .
Note: The truth-value of the proposition is separa te from the proposition (i.e., the meaning of the 
statement). The proposition means the same thing in every possible world, but the truth-value 
may be different in different possible worlds and is not necessarily relevant to every use of the 
proposition. Documenting the truth-value of a proposition is out of scope for SBVR and 
belongs to the domain of data management or rules enforcement. 
Reference Scheme: a closed logical formulation  that means  the proposition
Reference Scheme: a statement  of the proposition
question
Definition: meaning  of an interrogatory
Note: The word “question” has two common meanings :  first, a written or spoken expression of 
inquiry, and second, the meaning of such an inquiry. By the second definition, a single question could be asked in two languages. But by the first definition, using two language results in two expressions, and ther efore, two questions. The concept ‘ question
’ is here 
defined in the second sense (meaning) and should not be confused with the expression or representation of a question
.
Reference Scheme: a closed projection  that means  the question
28                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.38.3.2 Kinds of Proposition
Figure 8.5 - Kinds of Proposition
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by two different inte rpretations. See Clause 13 and Annex C.
fact  FL
Definition: proposition  that  is taken as true
Note: How one ascertains what is true, whether by asse rtion, observation, or other means, is outside 
the scope of this specification.  However, taking  a proposition as true must be consistent with 
epistemic commitment. The concept ‘ fact’ is here defined to be consistent with the operations 
of truth-functional logic, which produce results based on true and false.
element of guidance
General Concept: proposition
Definition: means that guides, defines, or constrains some aspect of an enterprise
Note: This sense of ‘means’ (as in ‘ends and means’ , rather than ‘is meant as’) arises from the 
Business Motivation Model  [BMM] .
Note: The formulation of an element of guidance is under an enterprise’s control by a party 
authorized to manage, control or regulate the enterprise, by selection from alternatives in 
response to a combination of assessments.

Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                     29rule
Definition: proposition  that is a claim of obligation  or of necessity
Dictionary Basis: one of a set of explicit or understood re gulations or principles governing conduct or procedure 
within a particular area of activity ... a law or pr inciple that operates with in a particular sphere 
of knowledge, describing, or prescribing what is possible or allowable. [ODE]
8.4 Kinds of Expression
Figure 8.6 - Kinds of Expression
This diagram shows the SBVR XMI Metamodel and SBVR vocabular y by two different interpretations. See Clause 13 and Annex C.
text
Source: Unicode 4.0.0 Glossary  [‘Character Sequence ’] 
General Concept: expression
Note: The concept  ‘text’ has no explicit reference scheme , but rather, is used as a target for 
reference schemes.
Note: A detailed vocabulary concerning text is provided by the Unicode specification.  Taking the 
concept ‘text’ from the Unicode specification does not mean that  a text is a Unicode encoding, 
but rather, it implies that a text can be represented by a Unicode encoding in electronic 
communications. Unicode encodings provide the common means of text representation in 

30                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.3word processors, mail systems, th e Internet, and so on. The encodings tend to be invisible to 
people writing and reading the text. 
Note: A text is taken as a sequence of characters. Interpretation of markup is not addressed by this 
document.
URI
Source: Uniform Resource Identifiers Vocabulary  [‘URI’]
Definition: text that identifies a resource as specified by [IETF RFC 2396]
Synonym: uniform resour ce identifier
Note: The concept  ‘URI’ is introduced into this specification in order to provide a universal context 
for reference schemes.
8.5 Connections between Concepts  and Things in the Business
8.5.1 Introduction
Figure 8.7 - Connections between Concepts and Things in the Business
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by two different inte rpretations. See Clause 13 and Annex C.

Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                     318.5.2 Extensions
 extension  FL
Source: ISO 1087-1 (English)  (3.2.8) [‘extension ’]
Definition: totality of objects [every thing ] to which a conce pt corresponds
Concept Type: role
General Concept: set
concept  has extension                                                                                                                                          FL
Definition: the extension  is the set of things  to which the concept  corresponds
concept1 is coextensive with  concept2 FL
Definition: the extension  of the concept1 is always  the extension  of the concept2
Note: Semantic integrations between communities  often involve recogn izing where different 
concepts (having different intens ions) have the same extensions in all possible worlds. Also, it 
is possible that concepts employing different methods of conceptualization have the same 
extension in all cases. For example, a noun concep t that specializes the concept ‘actuality’ can 
be coextensive with a verb concept.
Example: The individual noun concept defined as “the  thirtieth president of the United States” is 
coextensive with a general concept defined as “p resident of the United States in 1925”. The 
two concepts have the same extension (which includes only Calvin Coolidge) but they are different concepts.
8.5.3 Instances
instance  FL
Definition: thing  that is in an extension  of a concept
Concept Type: role
Example: The actual City of Los Angeles is an instance  of the concept  ‘city.’  It is also the one 
instance  of the individual noun concept  ‘Los Angeles.’
concept  has instance                                                                                                                                            FL
Definition: the concept  corresponds to  the instance
32                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.38.6 Connections between Kinds of Me aning and States of Affairs in the  
 Business
8.6.1 Connections between Propositions and States of Affair s in the Business
Figure 8.8 - Connections between Propositions and States of Affairs
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by two different inte rpretations. See Clause 13 and Annex C.
proposition  corresponds to  state of affairs
General Concept: ‘meaning  corresponds to  thing ’
Definition: the state of affairs  is posited by  the proposition  and if the  state of affairs  were actual , the 
proposition  would be true
Note: If the proposition  is a simple proposition formulated using a single main verb, then the state  
of affairs  can be understood as an in stance of that verb concept that involves in each verb 
concept role of that verb concep t the thing or things specified by the proposition as filling that 
verb concept role.  
 If the proposition is formulated using a more complex formulation involving implication, conjunction, or disjunction, the relationship between the proposition and the corresponding 
states of affairs is bound up with the way in wh ich such propositions are determined to be true 

Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                     33or false, as specified in Clauses 21 and 24.  But ultimately each of those is based on the 
correspondence of the state of affa irs to individual verb concepts.
8.6.2 Connections between Propositions  and Actualities in the Business
Figure 8.9 - Connections between Propositions and Actualities
This diagram shows the SBVR XMI Metamodel and SBVR vocabular y by two different interpretations. See Clause 13 and Annex C.
proposition  is true                                                                                                                                                                                FL
Definition: the state of affairs  that the proposition  corresponds to is actual 
Note: A proposition is true if and only the state of  affairs to which it corresponds is actual, regardless 
of whether that state of affairs has been actual  in the past or will be actual in the future.
Note: A proposition can be true with respect to one possible world and false with respect to another.  
See “possible world” in Clause 24.
proposition  is false                                                                                                                                                                              FL
Definition: the state of affairs  that the proposition  corresponds to is not actual
proposition  is necessarily true                                                                                                                     FL
Definition: the proposition  corresponds to  an actuality  in all possible worlds
Note: A proposition is considered to be necessarily tr ue if it is true by definition - the definitions of 
relevant concepts make it logically impo ssible for the proposition to be false. 

34                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.3proposition  is possibly true  
Definition: the proposition  corresponds to  an actuality  in some possible world     
Possibility: A proposition  that is possibly true  corresponds to  an actuality
proposition  is obligated to be true                                                                                                               FL
Definition: the proposition  corresponds to  an actuality  in all acceptable worlds
Note: The concept ‘acceptable world’  is described in Clause 24.
proposition  is obligated to be false                                                                                                               FL
Definition: the proposition  does not correspond to  an actuality  in any acceptable world
proposition  is permitted to be true                                                                                                              FL
Definition: the proposition  is not obligated to be false
Note: The concept ‘acceptable world’  is described in Clause 24.
8.6.3 Connections between Elem ents of Guidance an d States of Affair s in the Business
Figure 8.10 - Connections between Elements of Guidance and States of Affairs
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by two different inte rpretations. See Clause 13 and Annex C.

Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                     35element of guidance  authorizes  state of affairs
Definition: the element of guidance  entails that the state of affairs  may  be an actuality
Synonymous Form: element of guidance  gives permission for  state of affairs
element of guidance  obligates  state of affairs
Definition: the element of guidance  entails that the state of affairs  must  be an actuality
element of guidance  prohibits  state of affairs
Definition: the element of guidance  entails that the state of affairs  must not  be an actuality
8.6.4 Connections between Roles and the Things in th e Business that Play Them
Figure 8.11 - Connections between Roles and the Things that Play Them
This diagram shows the SBVR XMI Metamodel and SBVR vocabular y by two different interpretations. See Clause 13 and Annex C.
state of affairs  involves thing  in role  FL
Definition: the thing  plays the role in the state of affairs , and, if the  role is a verb concept role  and 
the state of affairs  is an actuality , the state of affairs  is an instance  of the verb concept  
that has the role
Synonymous Form: thing  fills role in state of affairs

36                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.3Note: If the role is a general concept, it is necessarily a situational role  and the state of affairs is a 
“situation” for which the role is defined (see 14.3.2).
Note: This verb concept is used to capture the fact of involvement of a thing in an actuality that is an 
instance of a verb concept, or more generally, in  a state of affairs whether or not it is an 
actuality. 
8.7 Connections between Expressi ons and Things in the Business
Figure 8.12 - Connections between Expressions and Things
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by two different inte rpretations. See Clause 13 and Annex C.
res is sensory manifestation of  signifier
term  denotes thing
Definition: the thing  is an instance  of the concept  that is represented by  the term
thing  has name
Definition: the thing  is the instance  of the individual noun concept  that is represented by  the 
name
Synonymous Form: name  references thing

Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                     37Note: A use of an individual noun concept by its name denotes the thing that is in the extension of the 
individual noun concept. 
 statement  denotes state of affairs
Definition: the statement  indicates  the state of affairs  that is posited by the proposition  that is 
expressed by  the statement
8.8 Necessities Concerning Extension
The following statements of nece ssity apply to the relationships between a mean ing and its extension. Other necessities stated 
in the context of the SBVR Vocabulary  concern meanings and their representations.  But the following necessities are about the 
correspondence of meanings to things in the universe of di scourse; i.e., the world of th e organization that uses the 
Terminological Dictionary and/or Rulebook.
Necessity: Each  concept  has exactly one extension .
Necessity: A thing  is an instance  of a concept  if and only if the thing  is in the extension  of the 
concept .
Necessity: Each instance  of a verb concept  is an actuality .
Necessity: Each  proposition  corresponds to  exactly one state of affairs .
Necessity: Each  proposition  that is true  corresponds to  exactly one actuality .
Necessity: Each actuality  that is an instance  of a verb concept  involves  some thing  in each role of 
the verb concept .
Necessity: Each thing  that fills a role in an actuality  is an instance  of the role.
Necessity: An actuality  is an instance  of a verb concept  if the actuality  involves  a thing  in a role of 
the verb concept .
Necessity: If a concept  incorporates  a characteristic  then each  instance  of the concept  is an 
instance  of the role of the characteristic .
Necessity: If a concept1 is coextensive with  a concept2 then the  extension  of the concept1 is the 
extension  of the concept2.
Necessity: Each  instance  of a role that ranges over  a general concept  is an instance  of the 
general concept .
Necessity: A thing  is an instance  of a verb concept role  if and only if the  thing  fills the verb concept  
role in an actuality .
Necessity: A thing  fills a verb concept role  in an actuality  if and only if the  actuality  is an instance  
of  the verb concept  that has the verb concept role .
Necessity: Each  individual noun concept  that corresponds to  a thing  always  corresponds to  that 
thing .
Necessity: Each  individual noun concept  corresponds to  at most one  thing .
38                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.3
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                     399 Communities and Authorities
9.1 Communities and Subcommunities
9.1.1 Community
Figure 9.1 - Community and Kinds of Community
community
Definition: group of people having a partic ular unifying charact eristic in common  
Dictionary Basis: group of people ha ving a religion, race, profession, or  other particular characteristic in 
common [NODE ‘community’]
Reference Scheme: a URI of the community
Example: The Car Rental Community  -- people who work in the car rental business
Example: The EU-Rent Community  -- all EU-Rent employees
Example: The EU-Rent German Community  -- employees of EU-Rent’s German division
community  has URI
Definition: the URI uniquely identifies the community
Necessity: Each  URI is the URI of at most one  community .
subcommunity
Concept Type: role
Definition: community  that is a distinct grouping within another  community  
Dictionary Basis: distinct grouping within a community [NODE ‘sub-community’]

40                                                                                                       Semantics of Business Vo cabulary and Busine ss Rules, v1.3community  has subcommunity
Definition: the subcommunity  is a distinct grouping within the community  
9.1.2 Kinds of Community
semantic community
Definition: community  whose unifying characteristic is a shared understanding (perception) of the things 
that they have to deal with 
Example: The EU-Rent Community  -- those who share the body of concepts about general and specific 
things of importance to  the EU-Rent business.
semantic community  shares understanding of  concept
Synonymous Form: concept  has shared understanding by semantic community
speech community
Definition: subcommunity  of a given  semantic community  whose unifying characteristic is the 
vocabulary  and language  that it uses 
Dictionary Basis: group of people sharing a character istic vocabulary, and grammatical and pronunciation 
patterns for use in their normal intercommunication [W3ID ‘speech community’]
Example: The EU-Rent German Community  shares the German-based vocabul ary of designations used in 
EU-Rent’s business.  The designations include German words for EU-Rent’s concepts plus 
designations adopted from other languages.
semantic community  has speech community
Necessity: Each  speech community  is of exactly one  semantic community .
language
Definition: system of arbitrary signals (such as voice sounds or written symbols) and rules  for combining 
them as used by a nation, people, or other distinct community  
Source: based on  AH
Note: A language can be a natural language or an unnatural one, such as a computer language or a 
system of mathematical symbols.
Note: A language is often identified by its name. ISO provides names of many languages in ISO 639-2 
(English)  and provides short (at most 3 letters) language-independent codes in ISO 639-2 
(Alpha-3 Code) .
Example: English, Fr ench, German, Arabic
Example: Moroccan Arabic (a dialect of Arabic)
Example: Unified Modeling Language (a graphical modeling language)
speech community  uses  language
Definition: the speech community  communicates in the language  
Necessity: Each  speech community  uses  exactly one  language .
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                     419.2 Authorities
Certain organizations, called authorities , have the need and the standing to creat e and adopt elements of guidance. Such 
organizations are not merely communities – they must conduct business in some organized fashion.
Figure 9.2 - Authority
authority  
Definition: organization with the standing to create or adopt elements of guidance
Dictionary Basis: power to require a nd receive submission : the right to e xpect obedience : superiority derived 
from a status that carries with it the right to command and give final decisions [MWUD ; 
authority’ 2a]
power to influence thought and opinion [MWUD ; authority’ 3a]
Example: a business (e.g., EU-Rent), a governmental body, a standards organization, a professional 
society, a club, a homeowner’s association
Note: People who create, adopt or use elements of guidance must understand the concepts on which 
they are based. Therefore, any person working wi thin an authority who is involved in creating, 
adopting, and/or using an elem ent of guidance must be a member of the semantic community 
for each concept referenced within the st atement(s) for such element of guidance.
Note: An authority might be a specialist body that cr eates elements of guidance for other authorities 
to adopt, rather than  applying the elements of guidance itself.
Note: The group of people and organizations to wh ich given elements of guidance apply is often 
broader than the authority that has jurisdiction over the elements of guidance. Example: The 
group of people to whom the elements of guidance of an airline frequent-flyer program apply is much wider than the authority (airline or air line suborganization) that has jurisdiction over 
those elements of guidance.
Note: It is possible and common for a person or orga nization to be subject to business rules of more 
than one authority.
authority  has business jurisdiction over  element of guidance
Synonymous Form: element of guidance  is in the jurisdiction of  authority
Definition: the authority  defines  the element of guidance  or adopts  the element of guidance

42                                                                                                       Semantics of Business Vo cabulary and Busine ss Rules, v1.3
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      4310 Characteristics
10.1 Introduction
Figure 10.1 - Characteristics
10.2 Characteristic
characteristic  FL
Definition: verb concept  that has exactly one role 
Source: ISO 1087-1 (English)  (3.2.4) [‘characteristic ’] 
Definition: abstraction of a property  of an object [ thing ] or of a set of objects
Synonym: unary verb concept
Example: The verb concept  ‘shipment  is late’ whose instances are actualities of shipments being late. 
There is one instance of the verb conc ept for each shipment that is late.
Note: A characteristic always has exactly one role, but  it can be defined using verb concepts having 
multiple roles.
Example: The characteristic  ‘driver  is of age’ with this definition: “t he age of the driver is at least the 
EU-Rent Minimum Driving Age.”  The semantic formulation of this definition appears in the introduction to Clause 21 - Logical Formulation of Semantics.

44                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.310.3 Kinds of Characteristic
necessary characteristic
Definition: characteristic  that is always  true of each  instance  of a given  concept
Concept Type: role
concept  has necessary characteristic
Definition: the necessary characteristic  is always  true of each  instance  of the concept
Example: If the characteristic ‘car  is small’ is a necessary character istic of the concept ‘compact car’, 
then every compact car is always small.
essential characteristic
Source: ISO 1087-1 (English)  (3.2.6) [‘essential characteristic ’] 
Definition: characteristic  which is indispensable to understanding a concept
Synonym: incorporated characteristic
Concept Type: role
concept  incorporates  characteristic                                                                                                                           FL
Definition: the characteristic  is an abstraction of a property  of each  instance  of the concept  and is 
one of the characteristics  that makes up the concept
Synonymous Form: characteristic  is essential  to concept
Synonymous Form: concept  has essential  characteristic
Concept Type: is-property-of verb concept
Note: Every characteristic incorporat ed by a concept is a necessary ch aracteristic of the concept, but 
not every necessary char acteristic of the concept is incorp orated by the concept. Only those 
that are part of what makes up the concept are considered to be incorporated. Given an 
intensional definition of a concept, incor porated characteristics include all of these:
1. characteristics incorporated  by the definition’s more general concept (recursively)
2. the definition’s delimiting characteristics
3. characteristics intrinsic to the delim iting characteristics (see example below)
4. any conjunctive combination of any of the characteristics above
Given an extensional definition, one that uses disjunction, characteristics that are found on 
each side of the disjunction are incorporated characteristics.  Two definitions can define the 
same general concept by producing the same se t of incorporated char acteristics.  The two 
definitions can directly identify  different sets of incorporated  characteristics (1 and 2 above) 
that are sufficient to dete rmine the others (3 and 4 above). The way incorporated 
characteristics fall into 1 through 4 above can differ from one definition to another while 
producing the same overall set.
Example: The concept “wrecked rental  car”, defined as “rental car that  is nonoperational due to being in 
an accident”, incorporates th e following characteristics:
1. characteristics incorporated by the more ge neral concept ‘rental car’ - e.g., being a car, 
being a vehicle, being rentable, and (combining them all) being a rental car
2. the delimiting characteristic:  being no noperational due to being in an accident  
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      453. characteristics intrinsic to the delimiting ch aracteristics - e.g., being nonoperational and 
having been in an accident
4. all conjunctive combinati ons of the characteristics given above - e.g., being a 
nonoperational vehicle, being a wrecked car
Example: The concept  ‘qualified driver’ incorporates the characteristic  ‘driver  is licensed’ because it is 
necessary (by the defini tion of ‘qualified driv er’) that each qualifie d driver is licensed.
delimiting characteristic
Source: ISO 1087-1 (English)  (3.2.7) [‘delimiting characteristic ’] 
Definition: essential  characteristic  used for distinguishing a conc ept from related concepts
Concept Type: role
Note: Delimiting characteristics of a concept are inherited as essential characteristics by all 
categories of that concept.
implied characteristic
Definition: necessary characteristic  of a given  concept  that is not incorporated by  the concept
Concept Type: role
Necessity: A concept  has an implied characteristic  only if  it follows by logical implication  from some 
combination of incorporations of characteristics  by concepts  and/or structural rules  that 
the characteristic  is always  attributed to each  instance  of the concept .
concept  has implied characteristic
Definition: the implied characteristic  is a necessary characteristic  of the concept  and the  concept  
does  not incorporate  the implied characteristic
10.4 Concept Generalization/Specialization
more general concept
Source: ISO 1087-1 (English)  (3.2.15) [‘generic concept ’] 
Definition: concept  in a generic relation having the narrower intension 
Concept Type: role
Note: The narrower intension of a more general concept  means that the more general concept  
incorporates  fewer characteristics  than any of its categories . Thus, it is possible that a 
more general concept  has a larger extension  than its categories . 
category
Source: ISO 1087-1 (English)  (3.2.16) [‘specific concept ’] 
Definition: concept  in a generic relation having the broader intension 
Concept Type: role
Dictionary Basis: secondary or subordinate category [NODE ‘subcategory’]
Note: The broader intension of a category  means that the category  incorporates  more 
characteristics  than its more general concept . Thus, it is possible that a category  has a 
smaller extension  than its more general concept . 
46                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.3concept1 specializes concept2                                                                                                                                     FL
Definition: the concept1 incorporates  each  characteristic  that is incorporated by  the concept2 and 
the concept1 incorporates  at least one  characteristic  that is not incorporated by  the 
concept2
Synonymous Form: concept2 generalizes  concept1
Synonymous Form: concept1 has more general  concept2
Synonymous Form: concept2 has category1
Note: The extension of a concept that specializes an other is always a subset of the extension of the 
other, but not necessarily a proper subset. The differentiator that makes one concept more 
specific than the other is conceptual and does not necessarily restrict the extension of the 
concept.
Example: The noun concept  ‘whole number’ specializes the noun concept  ‘integer’, the differentiator 
being that whole numb ers are nonnegative.
Example: The individual noun concept  ‘Los Angeles’ specializes the concept  ‘city’, the differentiator 
being that Los Angeles is one particular city in California.
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                     4711 Concepts
11.1 Noun Concepts
11.1.1 Introduction
Figure 11.1 - Noun concepts
This diagram shows the SBVR XMI Metamodel and SBVR vocabular y by two different interpretations. See Clause 13 and Annex C.
11.1.2 Noun Concept
noun concept  FL
Definition: concept  that is the meaning  of a noun or noun phrase
Concept Type: concept type
Reference Scheme: a closed projection  that  defines  the noun concept

48                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.311.1.3 General Noun Concepts
general concept  
Synonym: general noun concept
Definition: noun concept  that classifies things  on the basis of their common properties
Source: based on  ISO 1087-1 (English)  (3.2.3) ['general concept ']
Concept Type: concept type
Necessity: The set of characteristics  that are incorporated by  a general concept  is not the  set of 
characteristics  that are incorporated by  another  general concept .
Note: A general concept incorporates a set of ch aracteristics which are a unique combination that 
distinguishes that general concept from all other general concepts.  See ‘ concept  
incorporates  characteristic ’.  If a general concept A and a general concept B have the very 
same incorporated characteristics , they are the same concept. If they have the very same 
necessary characteristics, they ar e logically equivalent and they denote the same things in all 
possible worlds.
Example: the concept ‘rental car’ corresponding to cars that are rentedExample: the concept ‘car’, the con cept ‘number’, the concept ‘person’
role  FL
Definition: noun concept  that corresponds  to things  based on their playing a part, assuming a function 
or being used in some  situation
Concept Type: concept type
Example: the role ‘drop-off location ’ of the verb concept ‘shipment  has drop-off location ’
Example: the role ‘shipment ’ of the verb concept ‘shipment  has drop-off location ’, which should not be 
confused with the gene ral concept ‘shipment ’ (which generalizes the role)
Example: the role ‘sum’ – a role of a number in relation to a set of numbers
Note: A role can be a general concept or a verb concept role. A role is always understood with 
respect to actualities of a particular verb concept or to other particular situations. 
role  ranges over  general concept
Definition: each  characteristic  that is incorporated by  the general concept  is incorporated by  the 
role
Note: Saying that a role ranges ov er a general concept is similar to  saying the role specializes the 
general concept in that the role incorporates every characteristic inco rporated by the general 
concept, and therefore, each in stance of the role is necessarily an instance of the general 
concept.  But “ranges over” is different in that it allows that both the role and the general 
concept incorporate the same characteristics - the genera l concept can incorporate a 
characteristic that its instances fill that role.
Note: Sometimes a role can be played by instances of  any of a variety of types. For example, a role 
‘customer’ might range over “person or organization”. This is not a case of a role ranging over multiple general concepts. Rather, it is a case of a role ranging over a single general concept 
that is defined extensionally. In this case the single general concept is defined as “person or 
organization”. In contrast, saying a role ranges over multiple general concepts means that any thing that fills the role is always an instance of  each of those general concepts. It is equivalent 
to saying the role ranges over a single, possibly anonymous, general concept whose incorporated characteristics are the union of those incorporated by the multiple general 
concepts. 
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                     49Note: A general concept ranged over by a role can be a situational role.
Example: The role ‘company ’ of the verb concept ‘company  employs person ’ ranges over the general 
concept ‘company’
11.1.4 Individual and Un itary Noun Concepts
unitary noun concept  
Synonym: unitary concept
Concept Type: role
Definition: noun concept  that corresponds to  at most one  thing  at a time
Concept Type: concept type
Note: A unitary noun concept has at most one instance at any given time in a given possible world, 
but the instance can change over time.
Note: Different definite descriptions of the same thing can represent differ ent unitary noun concepts 
that correspond to that thing.
Example: The unitary noun concept ‘Air Force One’: the airplane that is carrying the President of the 
United States, which may be a differ ent aircraft at different times.
individual noun concept  FL
Synonym: individual concept
Dictionary Basis: ISO 1087-1 (English)  (3.2.2) [‘individual concept ’]
Definition: noun concept  that corresponds to  at most one  thing  in all possible worlds
Concept Type: concept type
Necessity: No individual noun concept  is a general concept .
Necessity: No individual noun concept  is a verb concept role .
Note: Individual noun concepts are unitary noun con cepts whose extensions are necessarily invariant 
across all possible worlds.
Note: While each referring individual noun concept has at most one and the same instance in all 
possible worlds, there can be multiple individual noun concepts that correspond to the same thing. Different definite descriptions of th e same individual thing can represent different 
individual noun concepts that correspond to that thing. If an individual noun concept does not correspond to any thing in some world, it does not correspond to any thing in any possible world.
Note: A full understanding of ‘individual noun concept’ requires a full understanding of the 
Necessities in sub clause 8.8
Example: The individual noun concept ‘California’ w hose one instance is an i ndividual state in the 
United States of America.
50                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.311.2 Verb Concepts
11.2.1 Introduction
Figure 11.2 - Verb Concepts
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by  two different interpretations. See Clause 13 and Annex C.
11.2.2 Verb Concept
verb concept  FL
Definition: concept  that specializes  the concept  ‘state of affairs ’ and that  is the meaning  of a verb 
phrase that involves one or more  verb concept roles
Dictionary Basis: [SubeGFOL]: Proposi tional function, [GFOL] Predicate

Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                     51Note: A propositional function becomes a proposition when  it is closed; it is closed by binding it to a 
logical constant (an individual noun concept) or a quantified variable (that ranges over some possibly qualified noun concept). 
Note: Each instance of a verb concept
 is a state of affairs . For each instance, each role of the verb 
concept  is one point of involvement of something in that state of affairs.
Note: Two verb concept definitions define the same verb concept if they reveal the same 
incorporated characteristics and the same verb concept roles. 
Concept Type: concept type
Necessity: Each  verb concept  has at least one verb concept role .
Necessity: Each proposition  that is created by binding all the verb concept roles  of a given verb 
concept  means what the definition  of the verb concept  defines it to mean .
Necessity: The definition  that represents  each  verb concept  is consistent with and defines exactly the 
complete set of propositions  that can be created by quantifying each  verb concept role  of 
the verb concept
Note: A verb concept role is played by a thing in the domain of discourse - the world of interest.  A 
verb concept is 'bound' by specifying the thing(s) that play the verb concept role. Linguistically those things can be specified by a quantified noun phrase or by an individual noun concept or by a pronoun that refers to a specific thing. 
Reference Scheme: a verb concept wording
 of the verb concept
Reference Scheme: a closed projection  that  defines  the verb concept
11.2.3 Verb Concept Role
verb concept role
Definition: role that specifically characterizes its instances  by their involvement in an actuality  that is 
an instance  of a given  verb concept
Concept Type: concept type
Reference Scheme: a placeholder  that represents  the verb concept role
Reference Scheme: a variable  that maps  to the verb concept role
Reference Scheme: a characteristic  that has the verb concept role
Necessity: Each  verb concept role  is in exactly one  verb concept .
Necessity: No verb concept role  is a general concept .
Note: A verb concept role is fundamentally understood as a point of involvement in actualities that 
correspond to a verb concept.  Its incorporated characteristics come from the verb concept - 
what the verb concept requires of  instances of the role.  It is  possible that two verb concept 
roles incorporate the same characteristics, such as when a binary verb concept means the same 
thing when roles are reversed, as in ‘person  is married to person ’.
verb concept  has  role  FL
Definition: the role is an abstraction of a thing  playing a part in an insta nce of the verb concept
Synonymous Form: verb concept role  is in verb concept
52                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.311.2.4 Verb Concepts and Propositions
proposition  is based on verb concept
Definition: the proposition  is formulated using the verb concept  
Example: The EU-Rent business rule that is expressed as “It is obligatory that each rental specifies a car 
group.” (or, in RuleSpeak, “A re ntal must have a car group.”) is based on the EU-Rent verb 
concept ‘rental  specifies car group ’.
11.2.5 Kinds of Verb Concept
binary verb concept  FL
Definition: verb concept  that has exactly 2 roles
Example: The verb concept  ‘shipment  has drop-off location ’ whose instances are actualities of 
shipments having drop-off locations.
Example: The verb concept  ‘number  is greater than number ’ whose instances are actualities of numbers 
being greater than other numbers, there being one instance for every pa ir of numbers where 
one is greater than the other.
Note: A verb concept can have two roles th at seem to be identical (e.g., ‘person  is married to person ’ 
where each role can be called ‘spouse’). Even th ough they incorporate th e same characterstics, 
they are distinct in that they  indicate two distinct points of  involvement in each actuality the 
verb concept corresponds to. 
unary verb concept
See: characteristic
general verb concept  FL
Definition: verb concept  that has at least one  open verb concept role  that has not been closed with 
an individual noun con cept
Concept Type: concept type
unitary verb concept  FL
Definition: general verb concept  that has exactly one  instance  in a possible world at a given time
Necessity: Each  role of a unitary verb concept  ranges  over  a unitary noun concept .
Necessity: At least one  role of a unitary verb concept  ranges over  a unitary noun concept  that is a 
general concept .
Note: Unitary verb concepts allow individual stat es of affairs that are needed in a business 
vocabulary to be included in a body of shared meanings. 
Note: Changes in the extensions of the unitary noun concepts that fill the roles of a unitary verb 
concept cause the unitary verb  concept to corres pond to a different state of affairs. 
Example: “The President ( a situational role ) flies to the alternate seat of government ( a situational role ) 
on Air Force One ( a situational role )”. The single state of affairs in the extension changes as, 
over time, different people, places  and aircraft fill the roles. 
Example: “the consolidated global account ( a situational role ) is filed in the base currency ( a situational 
role) in the compliant format ( a situational role )” specializes the verb concept “account is filed 
in currency in acceptable format”.  It defines the unitary verb concept that currently has the 
extension “the consolidated global account is filed in Swiss Francs in XBRL”
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                     53individual verb concept  FL
Concept Type: verb concept , proposition
Definition: verb concept  that has each  verb concept role  closed by an individual noun concept  and 
that corresponds to  exactly one  state of affairs  in all possible worlds at all (relevant) times
Definition: proposition  that is derived by closing each  role of a verb concept  with an individual noun  
concept
Note: Individual verb concepts allow individual st ates of affairs that are needed in a business 
vocabulary to be included in a body of shared meanings. 
Necessity: Each  role of an individual verb concept  is filled by  an individual noun concept .
Example: “EU-Rent was incorporat ed in Luxembourg in 1991” and “EU-Corp was incorporated in 
Geneva in 1993” are individual verb concepts that are derived from the verb concept “company was incorporated in ju risdiction in calendar year”. 
Example: “EU-Corp has owned EU-Rent since 1993” is an individual verb concept that is derived from 
the verb concept “company has owne d company since calendar year”. 
11.3 Reference Schemes
Figure 11.3 - Reference Scheme
This diagram shows the SBVR XMI Metamodel and SBVR vocabular y by two different interpretations. See Clause 13 and Annex C.
reference scheme  FL
Definition: chosen way of identifying instance s of a given  concept
Note: A reference scheme  is a way of referring to instances of a concept  by way of related things 
that are either lexical or are otherwise identi fiable. A reference scheme usually uses one or 

54                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.3more verb concept roles of binary verb concepts  in order to identify an  instance of a concept 
from facts about the instance. A reference scheme can also us e one or more characteristics. 
Note: A reference scheme  can be partial or complete. It is complete if it can always be used to 
refer to every instance of a con cept. An overall complete refe rence scheme for a concept can 
result from there being multiple partial reference schemes for that concept, its more general concepts, and its categories.
Note: Choice of reference schemes must be based on uniqueness (providing an identifier that refers 
to exactly one thing), but it should consider more than uniqueness. It should also consider permanence – if the actualities c onsidered by the scheme change often, then references can 
become invalid. A reference scheme should also not lead into an inescapable reference cycle 
where things only identify each other, but should lead either directly or indirectly to an 
expression.  It should also consider convenience and relevan ce from a business perspective.
Note: A verb concept role is used in a reference sche me in either of two ways. A simple use of a verb 
concept role involves a single instance of the ve rb concept role in each reference based on the 
scheme. An extensional use of a verb concept role  involves the entire set of related instances of 
the verb concept role in each reference based on the scheme.
Note: A reference scheme implies that there is unique ness – that whatever facts are used to reference 
an individual thing uniquely identify that one thing.
Reference Scheme: the set
 of verb concept roles  that are simply used by the reference scheme  and the 
set of verb concept roles  that are extensionally used by the reference scheme  and the 
set of characteristics  that are used by  the reference scheme
reference scheme  is for concept  FL
Definition: instances  of the concept  can be identified using the reference scheme   
Synonymous Form: concept  has reference scheme
Necessity: Each reference scheme  is for  at least one concept .
reference scheme  simply uses verb concept role  FL
Definition: any given  instance  of the verb concept role , which is of a binary verb concept , serves as 
identification or partial identification of an instance  of the concept  having  the reference  
scheme  where the given  instance  is related by way of the binary verb concept  that has 
the verb concept r ole
Synonymous Form: reference scheme  has simply used role
Necessity: Each verb concept role  that is simply used by  a reference scheme  is in a binary verb  
concept .
Example: A reference scheme for ‘car  model’ simply uses the ‘name ’ role of the binary verb concept ‘car  
model  has name ’.  An example of a reference based on this reference scheme identifies a 
particular car model as having the name “Chevrolet  Cavalier.”  The meaning of the reference is 
an individual noun concept having this definition: the car model that has the name “Chevrolet Cavalier.”
reference scheme  extensionally uses verb concept role  FL
Definition: a set of instances  of the verb concept role , which is of a binary verb concept , serves as 
identification or partial identification of an instance  of the concept  having  the reference  
scheme  where the set is the set of all instances  of the verb concept role  related by way of 
the binary verb concept  that has the verb concept role
Synonymous Form: reference scheme  has extensionally used role
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                     55Necessity: Each verb concept role  that is extensionally used by  a reference scheme  is in a binary  
verb concept .
Example: The reference scheme given above for the concept ‘ reference scheme ’ itself exemplifies 
extensional use of roles.  Any particular reference scheme can be identified by the combination of what roles it simply uses, what roles it ex tensionally uses, and what  characteristics it uses.  
For example, the reference scheme for ‘car mode l’ (in the example above) is identified by the 
facts that it simply uses only the ‘name
’ role of the binary verb concept ‘car model  has name ’, 
it extensionally uses no roles and it uses no characteristics.
reference scheme  uses characteristic  FL
Definition: having or not having the characteristic  serves as identification or  partial identification of an 
instance  of the concept  having  the reference scheme
Synonymous Form: reference scheme  has identifying characteristic
Note: Reference schemes generally use a characteristi c only in combination with one or more roles 
of binary verb concepts such that facts of those types about any referenced thing reduce the number matching instances down to two, one instance having the characteristic and not the other.  A reference scheme using no more than  a characteristic works on ly for the unusual case 
of a concept that always has at most two instances.
Example: A concept ‘tire position’, wh ich has only four instances, has a reference scheme that uses two 
characteristics, ‘tire position
 is in front’ and ‘tire position  is on the right’.  Any of the four 
positions can be identified by knowing whether or not it is in front and whether or not it is on the right.  The meaning of a reference based on this scheme is an individual noun concept having the more general concept ‘tire position’ and having a delimiting characteristic that is 
either being in front or not being in front an d another delimiting character istic that is either 
being on the right or not being on the right.
56                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.3
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      5712 Representations
12.1 Representations
12.1.1 Representation
Figure 12.1 - Representation
This diagram shows the SBVR XMI Metamodel and SBVR vocabular y by two different interpretations. See Clause 13 and Annex C.
representation
Definition: actuality  that a given  expression  represents  a given  meaning
Necessity: Each representation  has exactly one expression .
Necessity: Each representation  represents  exactly one meaning .
representation  has expression
representation  represents meaning
Synonymous Form: meaning  has representation
Synonymous Form: representation  has meaning

58                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.312.1.2 Representation Formality
Figure 12.2 - Representation Formality
expression  is unambiguous to  speech community
Definition: the expression  is understood by each member of the speech community  to represent 
exactly one and the same meaning
Note: In SBVR, a fully and accurately styled expression is assumed to be unambiguous. (Formal 
assessment of the expression, of course, may find that it is not.) The ve rb concept “expression 
is unambiguous to speech community” is not used for such expressions. 
Only informal statements (unstyled or partially styled) should use this verb concept. In 
communicating expressions, recipients need a sense of the viability of what is being 
communicated. Use of the verb concept to in dicate that an expre ssion is unambiguous 
indicates that an informal asse ssment has been made an d that the meaning of  the expression is 
thought to be clear. 
Caution should be exercised in this regard. Even expressions thought to be self-evidently 
unambiguous may be found not to be so.  Practitioners should generally err on the side of caution, especially in expressing elements of guidance.
Representation Formality
Definition: the segmentation  of the concept  ‘representation ’ that  classifies  a representation  based 
on whether or not it is ‘formal’
formal representation
Definition: representation  in which every word is annotated (‘ta gged’) in accordance with a notation that 
can be mapped to SBVR
Necessity: No formal representation  is an informal representation .
Necessity: The concept  ‘formal representation ’ is included in Representation Formality .
informal representation
Definition: representation  in which not every word is annotated (‘tagged’) in accordance with a notation 
that can be mapped to SBVR
Necessity: No informal representation  is a formal representation .

Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      59Necessity: The concept  ‘informal representation ’ is included in Representation Formality .
Note: Some of the words of an info rmal representation may be annotated -- i.e., defined, or ‘tagged’, 
terms, names, verbs, or keywords.
12.1.3 Representation Disambiguation
Figure 12.3 - Representation Contexts for Disambiguation
This diagram shows the SBVR XMI Metamodel and SBVR vocabular y by two different interpretations. See Clause 13 and Annex C.
designation context
Concept Type: role
Definition: concept  that characterizes the domain of usage within which the expression  of a 
representation  has a unique meaning  for a given  speech community  
Example: When EU-Rent us es the term ‘site’:
* within the context of the concept termed ‘vehicle rental’ (another EU-Rent term), it denotes 
EU-Rent’s shared understanding of  a ‘place from which EU-Rent vehicles are picked up and 
returned’.
* within the context of the con cept termed ‘vehicle maintenance’ (another EU-Rent term), it 
denotes EU-Rent’s shared understanding of a ‘pl ace where EU-Rent’s vehicle fleet is serviced 
and repaired’.
Example: When EU-Rent uses the term ‘customer’:
* within the context of the concept termed ‘vehicle rental’ (another EU-Rent term), it denotes 
EU-Rent’s shared understanding of ‘rental-cu stomer-ness’ (Definition: ‘individual who 
currently has a EU-Rent car  on rental, or has a reservation for a future car rental, or has rented 
a car from EU-Rent in the past 5 years’).
* within the context of the concept termed ‘vehicle sales’ (another EU-Rent term), it denotes 
EU-Rent’s shared understanding of ‘car-purchas er-ness’ (Definition:  ‘individual who has 
purchased at least one car fr om EU-Rent that is still within its warranty period’).
representation  is in designation context
Definition: the representation  is recognized and used in discourse regarding the designation context  

60                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.3subject field
Definition: field of specific knowledge
Source: ISO 1087-1 (English)  (3.1.2) [‘subject field ’]
representation  is in subject field
Definition: the representation  is recognized and used in discourse regarding the subject field  
12.2 Designations
12.2.1 Designation
Figure 12.4 - Designation
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by two different inte rpretations. See Clause 13 and Annex C.
designation
Source: ISO 1087-1 (English)  (3.4.1) [‘designation ’] 
Definition: representation  of a concept  by a sign which denotes it
Note: In common usage, the signifier of a designati on is used to refer to  the instances of the 
designated concept. The designation, as defined here and in ISO 1087-1, does not refer to those instances directly, but relates the signifier to the concept. See ‘concept has instance’ in 8.5.3.
Necessity: Each designation
 represents  a concept .
Reference Scheme: the signifier  of the designation  and a namespace  that includes  the designation
Reference Scheme: A verb concept wording  that demonstrates  the designation
Reference Scheme: the signifier  of the designation  and the concept  that is represented by  the designation

Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      61concept  has  designation
Definition: the designation  represents  the concept
signifier
Definition: expression  that is a linguistic unit or pattern, such as a succession of speech sounds, written 
symbols or gestures, used in a designation  of a concept  
Concept Type: role
Example: the sequence of ch aracters “car” used in a designation  of the concept  ‘automobile’ or used in 
a designation  of the concept  ‘railroad car’
Example: the sequence of speech sounds (t), (r), and (e ) used in a designation  of the concept  ‘tree’
Example: The graphic “€” used in a designation  of the concept  ‘Euro’
designation  has signifier
Definition: the signifier  is the expression  of the designation
12.2.2 Verbal and Nonverbal Designations
Figure 12.5 - Verbal and Nonverbal Designations
This diagram shows the SBVR XMI Metamodel and SBVR vocabular y by two different interpretations. See Clause 13 and Annex C.
term
Source: ISO 1087-1 (English)  (3.4.3) [‘term’]
Definition: verbal designation  of a general concept  that is in a given  subject field
General Concept: designation
Note: A term is typically formed using a common noun or noun phrase.

62                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.3Example: EU-Rent agrees the word ‘ car’ denotes its shared understandi ng of ‘rental-car-ness’ within 
<rental context>.
Example: EU-Rent agrees the word ‘vehicle’ denotes  its shared understanding of ‘car-ness’ within 
<rental context>.
Example: EU-Rent agrees the word ‘customer’ denotes its shared understanding of ‘rental-customer-
ness’ within <rental context>.
Example: EU-Rent agrees the word ‘c ustomer’ denotes its shared unders tanding of ‘car-p urchaser-ness’ 
within <car-sales context> -- i. e., when EU-Rent disposes of car s after they reach their mileage 
or age threshold.
Example: EU-Rent agrees the word ‘r enter’ denotes its shared understan ding of ‘rental-customer-ness’.  
(within any context).
name
Source: ISO 1087-1 (English)  (3.4.2) [‘appellation ’] 
Definition: verbal designation  of an individual noun concept  
General Concept: designation
Necessity: No name  is a term.
Note: The expression of a name is typically a proper noun.
verb symbol
Definition: designation  that represents  a verb concept  and that is demonstrated by  a verb concept  
wording   
Reference Scheme: a verb concept wording  that incorporates  the verb symbol
Example: In the expre ssion, ‘Each customer  rents a car’ , ‘rents’ is a verb symbol  denoting a verb 
concept .
Example: In the expression, ‘A driver  of a car  returns the car  to a branch office ’, ‘of’ is a verb symbol  
for one verb concept (relat ing a driver to a car) and ‘returns to’ is another verb symbol  
denoting a verb concept  (relating a driver to a car and a branch office).
nonverbal designation
Definition: designation  that is not expressed as words of a language
Necessity: No nonverbal designation  is a term.
Necessity: No nonverbal designation  is a name .
Note: A verbal designation, such as a term or na me, can contain parts that  are nonverbal.  Some 
abbreviations are nonverbal while others, bein g expressed as words, are terms or names.
icon
Definition: nonverbal designation  whose signifier  is a picture
Dictionary Basis: a usu. pictorial representation [MWCD ‘icon’]
Example:  as a designation for the concept ‘u-turn’

Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      6312.2.3 Designation Preferences
Figure 12.6 - Designation Preferences
This diagram shows the SBVR XMI Metamodel and SBVR vocabular y by two different interpretations. See Clause 13 and Annex C.
speech community  regulates its usage of  signifier
preferred designation
Definition: designation  that  is selected by its owning speech community  for a given  concept  from 
among alternative designations  for that concept  as being most desirable or productive
Example: EU-Rent’s preferred designations for in dicating the USA Dollar, Canadian Dollar, and 
Mexican Peso are, respectively, “USD”, “C AD”, and “MXN” (ISO 4217 currency codes).
prohibited designation
Definition: designation  that  is declared unacceptable by its owning speech community
Example: In EU-Rent, use of the dollar sign ($) by it self is prohibited, to avoid confusion between the 
USA Dollar, Canadian Dollar, and Mexican Peso. 
Note: What is prohibited is the use of a given ex pression to represent a given meaning. The same 
expression may be permitted, even pr eferred, to represent another meaning.
Necessity: No preferred designation  is a prohibited designation .

64                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.312.2.4 Placeholder and Verb Concept Role Designation
Figure 12.7 - Placeholder and Verb Concept Role Designation
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by two different inte rpretations. See Clause 13 and Annex C.
verb concept role designation
Definition: designation  that is of a verb concept role  and that  is recognizable in use in the context of 
another role of the same verb concept  
Necessity: No verb concept role designation  is a term.
Necessity: No verb concept role designation  is a placeholder .
Necessity: No verb concept role designation  represents a situational role .
Note: A verb concept role designation should not be confused with a placeholder or with a term for a 
situational role, even though all of these can have the same expression. A situational role is a general concept and is not a verb concept role.
Note: A verb concept role designation should not be  confused with a placeholder, which is part of a 
verb concept wording. In uses of a verb concept wordin g, placeholders are replaced. A verb 
concept role designation can replace a placeholde r. Verb concept role designations occur in 
statements and definitions to refer to what fills the role. 
Example: The verb concept role design ation, ‘CEO’, for a role in the verb concept ‘corporation has CEO’ 
does not represent a situational role and is not the same thing as the ‘CEO’ placeholder in that 
verb concept wording.  Here we  see different designations have the same signifier, ‘CEO’.  
The verb concept role designation  represents th e verb concept role in the context of using the 
verb concept, such as in the phrases ‘EU-Rent’s CEO’ and ‘the  CEO of some corporation’.  
But a situational role, even if defined in terms of the verb concept can be used independently, 
as in the statement, ‘Every CEO is a person’.  The placehol der ‘CEO’ of the verb concept 
wording ‘corporation has CE O’ is part of the form and gets replaced in each use of the form.  
In the statement, ‘EU- Rent has exactly one CEO’, the ‘CEO ’ placeholder of the verb concept 
wording ‘corporation has CEO’ is replaced by ‘exactly one CEO’, comprised of  a quantifier 
and the verb concept role designation ‘CEO’, which is understood to represent the verb concept role because of its context: it is used in relation to a corporation.
Note: Sub clause 23.7.4 shows an example of a verb  concept role designatio n, ‘prior example’, and 
shows examples of verb concept roles having no verb concept role designation.

Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      65placeholder
Definition: designation  of a verb concept role  within a verb concept wording  marking a place where, 
in uses of the verb concept wording , an expression  denotes what fills the verb concept  
role
Necessity: Each placeholder  is in exactly one verb concept wording . 
Necessity: Each placeholder  represents  exactly one verb concept role .
Necessity: Each placeholder  of each verb concept wording  of a verb concept  represents  a verb 
concept role  of the verb concept .
Necessity: Each placeholder  has at most one starting character position .
Necessity: Each placeholder  of a verb concept wording  that has a text has a starting character  
position .
Reference Scheme: the verb concept wording  that has the placeholder  and the expression  of the 
placeholder  and the starting character position  of the placeholder
Note: The expression of a placeholde r often consists of the signifier  of a designation used by the 
placeholder, but it can include other things such as delimiting characters (as in ‘[proposition] is 
true’) or a subscript (as in ‘proposition1 is true ’) by which the placeholder can be distinguished 
within the verb concept wording that has it. A placeholder need not use a designation (as in ‘… is true’).
12.3 Wordings for Verb Concepts
12.3.1 Verb Concept Wording
The concepts defined in this sub clause ar e intended to provide a means of representing syntactic elem ents of a language that 
are used to represent verb con cepts in statements and definitions. The elements defined here are intentionally minimal and may 
or may not be adequate for specific languages.
66                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.3Figure 12.8 - Verb Concept Wording
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by two different inte rpretations. See Clause 13 and Annex C.
verb concept wording
Definition: represen tation  of a verb concept  by an expression  that has a syntactic structure involving 
a signifier  for the verb concept  and signifiers  for its verb concept roles
Note: The verb concept wording relates to a signifier for the verb concept by ‘verb concept wording  
incorporates  verb symbol ‘. The verb concept wording relates to signifiers for the verb 
concept roles by ‘verb concept wording  has placeholder ’.
Note: A verb concept wording is not a designation fo r a verb concept. It is a syntactic structure of 
expressions that is a pattern for using a designation of the verb concept in definitions and statements. 
Necessity: Each verb concept wording
 represents  exactly one verb concept .
Necessity: Each verb concept wording  has at least one placeholder .
Necessity: At most one role of a verb concept  that  has a verb concept wording  is not represented 
by a placeholder  of the verb concept wording .
Necessity: No verb concept wording  is a designation .
Necessity: Each verb concept wording  demonstrates at most one designation .
Necessity: If a designation  is demonstrated by  a verb concept wording  of a verb concept  then the 
verb concept  has the designation .
Example: The verb concept wording  ‘customer  rents car ’ incorporates the verb symbol  ‘rents’ and has 
two placeholders. One placeholder  uses the designation  ‘customer’ and is at the starting  
character position  1. The other placeholder  uses the designation  ‘car’ and is at the starting  
character position  16.
Example: The verb concept wording  ‘driver  of car ’ demonstrates the verb symbol  ‘of’ and has two 
placeholders, one using the designation  ‘driver’ at the starting character position  1, and the 
other using the designation  ‘car’ at the starting character position  11.
Example: The verb concept wording  ‘country  charges tax rate  on date ’ incorporates the verb symbol  
‘charges on’ that represents the same verb concept  as the verb concept wording . 

Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      67Note: Recognizing how a statement such  as, “A customer must rent at most one car”, fits the pattern 
or template of a verb concept wording, such as ‘customer  rents car ’, is part of the process of 
language parsing and interpretation and is not covered by this specification.
Note: In some languages, verb concept wordings occur that involve only a positioning of 
placeholders with no other designation — no verb or preposition.
Reference Scheme: the expression  of the verb concept wording  and a namespace  that  includes  the verb 
concept wording  
verb concept  has  verb concept wording
Definition: the expression  of the verb concept wording  represents the verb concept  as a 
grammatical structure of expressions  in some  language  
Definition: the verb concept wording  represents the verb concept  
verb concept wording  incorporates verb symbol
Definition: the verb concept wording  shows a pattern of using the expression  of the verb symbol  
plus expressions  of the placeholders for each of the roles  of the verb concept  that has 
the verb concept wording
Synonymous Form: verb symbol  is incorporated into verb concept wording  
Synonymous Form: verb concept wording  demonstrates designation
Necessity: Each verb concept wording  incorporates  at most one verb symbol .
Necessity: Each verb symbol  is incorporated into  at least one verb concept wording .
Note: If a verb concept wording demo nstrates a designation, the signifier of that designation is what 
is seen in the expression of the verb concep t wording when placeholder expressions have been 
removed.
12.3.2 Kinds of Verb Concept Wording
Figure 12.9 - Kinds of Verb Concept Wording
This diagram shows the SBVR XMI Metamodel and SBVR vocabular y by two different interpretations. See Clause 13 and Annex C.

68                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.3sentential form
Definition: verb concept wording  that is a pattern or template that can be used for stating a proposition  
based on a verb concept  
Example: ‘car  is used in rental agreement ’ is a sentential form  of a binary verb concept .
Example: ‘car  is unavailable’ is a sentential form  of a characteristic .
Example: Assuming there is a role ‘r enter’ ranging over the concept ‘customer’, the following can all be 
alternative sentential forms of the same verb concept:
car has renter
customer  rents car
car is rented by customer
renter  rents car
Necessity: Each role of the verb concept  that  has a sentential form  is represented by a 
placeholder  of the sentential form .
noun form
Definition: verb concept wording  that acts as a noun rather than forming a proposition
Note: A noun form can have a placeholder for each role of a verb concept, in which case the noun 
form result comes from the role the first placeholder is for. A noun form can also have one less placeholder than there are roles, in which case the noun form result comes from the role  that no 
placeholder is for. 
Example: ‘transferred car
 of car transfer ’ for the verb concept ‘car transfer  has transferred car ’. This form 
yields a transferred car. 
Example: ‘| number  |’for the verb concept ‘number  has absolute value ’. The form yields the absolute 
value of the number. 
Example: ‘number1 + number2’ for the verb concept ‘number1 + number2 = number3’. This form yields 
the third number (the sum of adding the first two numbers). 
Example: ‘transferring rental car ’ for the verb concept ‘car transfer  has transferred car ’. This form yields 
the car transfer, which is an action. Gerunds are used in noun forms like this for actions, 
events, and states. They are used in sentences li ke this: “A rental car must be cleaned before 
transferring the rental car.”
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      6912.4 Placeholders in Ve rb Concept Wordings
Figure 12.10 - Placeholders in Verb Concept Wordings
This diagram shows the SBVR XMI Metamodel and SBVR vocabular y by two different interpretations. See Clause 13 and Annex C.
verb concept wording  has placeholder
Definition: the placeholder  indicates a place for expr ession of what fills a role in the verb concept  
wording
Synonymous Form: placeholder  is in verb concept wording  
starting character position
Definition: positive integer  that is an ordinal position where a text starts within an encompassing text
Concept Type: role
placeholder  is at  starting character position
Definition: the expression  of the placeholder  is textual and occurs within a textual expression  of a 
verb concept wording  starting at the starting character position
Synonymous Form: placeholder  has starting character position
Note: If a placeholder is at a starting position within  a verb concept wording,  then the expression of 
the placeholder exactly matches the characters in the expression of the verb concept wording, 
character for character, from the starting char acter position through the full length of the 
placeholder’s expression. Placehol ders’ expressions do not ove rlap each other within the 
expression of a verb concept wording. If the ve rb concept wording demons trates a designation, 
the designation’s signifier appears within the part or parts of the verb concept wording’s expression that are not occupied by placeholders.
Note: See 23.7.4 for detailed examples showing various aspects of ve rb concept wordings, 
placeholders, and their star ting character positions.
placeholder  uses  designation
Definition: the expression  of the placeholder  incorporates  the signifier  of the designation  thereby 
indicating that that verb concept role  represented by  the placeholder  ranges over  the 
concept  represented by  the designatio n
Note: The means by which a placeholder incorporates  a designation depends on convention.  SBVR 
does not require a particular convention, bu t it uses one described in Annex A, SBVR 
Structured English.

70                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.3Example: The ‘proposition ’ placeholder in the verb concept wording ‘proposition  is true’ uses the 
designation ‘proposition’.  The st atement, “A fact is true,” is  understood to use that verb 
concept wording because a fact is a proposition, but “A line is true” is not recognized  as using 
that verb concept wording becau se a line is not a proposition.
Example: Consider two verb concept wordin gs for the same verb concept:  ‘rental  is returned on date ’ 
and ‘rental  has return date ’.  The second placeholders of the two forms represent the same role, 
but they use different designations (‘date’ and ‘ret urn date’).  If “Rental 876” denotes a rental, 
then the statement, “Rental 876 is returned on 30 June 2006,” is understood to use the first verb concept wording because “30 June 2006” is understood to denote a date, but the statement, “Rental 879 has 30 June 2006,” is not understood to use the second verb concept wording because “30 June 2006” is not understood to deno te a return date (only a date).  “Rental 879 
has the return date 30 June 2006” uses the second verb concept wording.
Example: In the verb c oncept wording ‘rental car
1 replaces rental car2’, both placeholders (‘rental car1’ 
and ‘rental car2’) use the same designation, ‘rental car’.
12.5 Statements
Figure 12.11 - Statement
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by two different inte rpretations. See Clause 13 and Annex C.
statement
Definition: representation  of a proposition  by an expression  that is non-paradoxical and meaningful 
and that  is a simple sentence with one declarativ e clause, or a complex sentence or group of 
sentences that together contain one or more declarative clauses 
Necessity: Each statement  expresses  exactly one proposition .
Reference Scheme: the expression  of the statement  and a  closed logical formulation  that formalizes the 
statement
Note: A statement combines a single expression with  a single meaning of that  expression.  If an 
expression is an ambiguou s sentence, one that represents two different propositions, each of 
the two representations is considered to be a separate statement.  See ‘ expression  is 
unambiguous to  speech community ’ in 12.1.2.
Note: A paradoxical expression is not an expressi on of a statement.  A paradox is independent of 
whether or not the truth-value is known.

Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      71Note: In sentences each declarative clause represents individually a given proposition that is its 
meaning.  Complex sentences an d groups of multiple sentence s can also represent a single 
proposition.  The terms “sentence” and “clause” are used in SBVR with their most common 
grammatical meaning
Note: Including a statement of a proposition in a desc riptive example does not assert the truth of the 
proposition.  It is simply an illustrative example of the concept.  This is unlike including a statement of the same proposition in a factbase wh ich, by definition, includes an assertion of 
“taken to be true.”
Necessity: Each  statement
 that represents  a given  proposition  and each  closed logical  
formulation  that means  that given  proposition  must  be synonymous, and both individually 
and together with all the others determine the proposition  i.e., the meaning .
Note: How the meaning of a statement is determined depends on the natural language in which it is 
expressed.  SBVR defines how to determine th e meaning of a closed logical formuation.  
statement  expresses proposition
Definition: the statement  represents  the proposition
Synonymous Form: proposition  has statement
72                                                                                                      Semantics of Business Voc abulary and Business Rules, v1.3
Semantics of Business Vocabula ry and Business Rules, v1.3        7313 Concept Definition
13.1 Definitions
Figure 13.1 - Definition
definition
Source: ISO 1087-1 (English)  (3.3.1) [‘definition ’]
Definition: representation  of a concept  by a descriptive statement [ expression ] which serves to 
differentiate it from related concepts
Definition: representation  (as through a word or phrase) expressing  the essential nature of a person or 
thing or class of persons or of things : an answer  to the question “what is x?” or “what is an x?”
Necessity: Each definition  represents  a concept .
Reference Scheme: the expression  of the definition  and a closed projection  that formalizes  the definition
Note: ‘ definition ’ is used in SBVR in the sense of the formal te rm “definiens.”
concept  has  definition
Definition: the definition  represents  the concept

74                 Semantics of Business Vocabulary and Business Rules, v1.3intensional definition
Source: ISO 1087-1 (English)  (3.3.2) [‘intensional definition ’] 
Definition: definition  which describes the intension of a concept  by stating the superordinate concept  
and the  delimiting ch aracteristics   
General Concept: definition
Necessity: No intensional definition  is an extensional definition . 
intensional definition  uses  delimiting characteristic
Definition: the delimiting characteristic  serves to distinguish the concept  defined by the intensional  
definition  from other concepts   
definite description
Definition: intensional definition  of an individual
Example: the car movement that has the movement id “UK-12345-abc-xyz”Necessity: Each  definition
 of an individual noun concept  is a definite description .
Necessity: Each  definite description  is the definition  of an individual noun concept .
Necessity: Each  definite descr iption  uses a reference sch eme  for the individual .
extensional definition
Source: ISO 1087-1 (English)  (3.3.3) [‘extensional definition ’]
Definition: description of a concept by enumerating all of its subordinate concepts under one criterion of 
subdivision
General Concept: definition
Necessity: No extensional definition  is an intensional definition . 
definition  serves as  designation
Definition: the definition  acts as a designation  of the conce pt defined by the definition
Note: In the case of a concept for which no designation is given, the concept is represented by its 
definition. 
derivable concept
Definition: concept  whose extension  can be determined from its definition  or from rules
designation  is implicitly understood
Definition: the designation  is generally understood by its owning community  without an explicit 
definition  for the concept  it designates
Semantics of Business Vocabula ry and Business Rules, v1.3        7513.2 Definitional Entries
Figure 13.2 - The Description, Example, No te, and Reference Elem ents of a Definition
description
Definition: representation  that  provides a detailed account of something, a verbal portrait 
Dictionary Basis: a spoken or written represen tation or account of a pe rson, object, or event [NODE ‘description’]
Necessity: No description  that portrays  a concept  is a descriptive example  that illustrates  that 
concept .
Necessity: No description  that portrays  a concept  is a note that comments on that concept .
Necessity: No description  that portrays  a concept  is a reference  that supports  that concept .
description  portrays  meaning
Note: The meaning of a description that portrays a concept is most likely not that concept.  A 
description can be a statement, in wh ich case, its meaning is a proposition.
descriptive example
Definition: representation  that provides descriptive material that is a sample of the thing defined 
Source: based on  MWCD  and NODE
Dictionary Basis: one (as an item or incident) th at is representative of all of a group or type [MWCD ‘example’]
Dictionary Basis: a thing characteristic of  its kind or illustrating a general rule [NODE ‘example’]
Necessity: No descriptive example  that illustrates  a concept  is a definition  of that concept .
Necessity: No descriptive example  that illustrates  a concept  is a description  that  portrays  that 
concept .

76                 Semantics of Business Vocabulary and Business Rules, v1.3Necessity: No descriptive example  that illustrates  a concept  is a note that comments on that 
concept .
Necessity: No descriptive example  that illustrates  a concept  is a reference  that supports  that 
concept .
Example: Chris Cushing is an example of EU-Rent’s concept of ‘rental customer’.
Example: The vehicle with VIN#88744332 is an example of EU-Rent’s concept of ‘rental car’.
descriptive example  illustrates  meaning
Note: The meaning of a descriptive example is typically a proposition.
note
Definition: representation  that annotates or explains
Necessity: No note  that comments on a concept  is a definition  of that concept .
Necessity: No note  that comments on a concept  is a description  that  portrays  that concept .
Necessity: No note  that comments on a concept  is a descriptive example  that illustrates  that 
concept .
Necessity: No note  that comments on a concept  is a reference  that supports  that concept .
Synonym: remark
Synonym: comment
note  comments on meaning
Note: The meaning of a note that comments on a con cept is most likely not that concept. A note is 
typically a statement whose meaning is a proposition.
comment
See: note
remark
See: note
reference
Definition: representation  that  is the mention or citation of a sour ce of information used to direct a 
reader elsewhere for addi tional information about a given  concept
Dictionary Basis: a mention or citation of a source of information in  a book or article [NODE ‘reference’]
Necessity: No reference  that supports  a concept  is a definition  of that concept .
Necessity: No reference  that supports  a concept  is a description  that  portrays  that concept .
Necessity: No reference  that supports  a concept  is a descriptive example  that illustrates  that 
concept .
Necessity: No reference  that supports  a concept  is a note that comments on that concept .
Example: ‘The Highway Code’ published by HMSO, 2005.Example: The descriptions of car models’ capacity , fuel economy, and performance taken from the 
manufacturers’ specifications.
reference  supports  meaning
Semantics of Business Vocabula ry and Business Rules, v1.3        7714 Structures in Concept Systems
14.1 Structural Connections between Things
14.1.1 Associations
Figure 14.1 - Association and Kinds of Association
association
Definition: verb concept  that has more than one  role and that  has a nonhierarchical subject-oriented 
connection drawn from experience, based on prac tical rather than theo retical considerations
Source: based on ISO 1087-1 (English)  (3.2.23) [‘associative relation ’, ‘pragmatic relation ’]
Dictionary Basis: to join (things) together or connect (one thing) with another [MWU verb (3) ‘associate ’]
Example: The verb concept ‘additional driver  is authorized in rental ’
Example: The verb con cept ‘car manufacturer  supplies car model ’
Example: The verb con cept ‘car manufacturer  delivers consignment  to branch ’

78                 Semantics of Business Vocabulary and Business Rules, v1.3property association
Definition: association  that is defined with respect to a given  concept  such that each  instance  of the 
association  is an actuality  that a given  instance  of the concept  has a particular property
Necessity: Each  instance  of each  property association  is an actuality  that a thing  has a particular 
property .
Dictionary Basis: a quality or trait belonging to a person or thing; [MWUD ‘property’]
Synonym: is-property-of verb concept
Example: The association ‘engine size  of car model ’
Example: The association ‘person  has eye color ’
is-property-of verb concept
See: property association
subject concept
Definition: concept  that provides a context for recognizing designations  used to attribute properties  to 
instances  of the concept
Concept Type: role
Example: In the phrase, “each rental’s drop-off date,”  the concept ‘rental’ is a subject concept with 
respect to recognizing the designation ‘drop-off da te’ representing a role in a verb concept that 
relates a rental to its drop-off date.
Example: In the phrase, “an assigned rental,” the con cept ‘rental’ is a subject concept with respect to 
recognizing the designation ‘assigned’ represen ting a characteristic attr ibutable to rentals 
(‘rental is assigned’).
Semantics of Business Vocabula ry and Business Rules, v1.3        7914.1.2 Partitive Connections
Figure 14.2 - Partitive Verb Concept
partitive verb concept
Definition: verb concept  where each  instance  is an actuality  that a given  part is in the composition of 
a given  whole
Source: based on ISO 1087-1 (English)  (3.2.22) [‘partitive relation ’] 
Dictionary Basis: to place, list, or rate as a part or comp onent of a whole or of a larger  group, class, or aggregate  
[MWU (2a) ‘include ’]
Necessity: Each partitive verb concept  is a binary verb concept .
Necessity: Each instance  of each  partitive verb concept  is an actuality  that a given  part is in the 
composition of  a given  whole .
Example: The verb concept ‘country  is included in region ’ 
An example of an instance of that verb concep t is that Sweden is included in Scandinavia.
Example: The verb concept ‘branch  is included in local area ’ 
Example: The verb concept ‘car model  is included in car group ’
Example: To reflect the compos ition of a mechanical pencil , the verb concepts: ‘barrel  is included in 
mechanical pencil ’, ‘lead-advance mechanism  is included in mechanical pencil ’, ‘lead (refill)  
is included in mechanical pencil ’, and ‘refill eraser  is included in mechanical pencil ’ [an 
example in ISO704 ]
Synonym: part-whole verb concept
Note: For more discussion and examples see:  Anne x B.3.4, C.7, as well as the EU-Rent examples in 
Annex G.

80                 Semantics of Business Vocabulary and Business Rules, v1.3part-whole verb concept
See: partitive verb concept
14.2 Structural Connect ion between Concepts
14.2.1 Categorization
Figure 14.3 - Categorization
categorization
Definition: proposition  that a given general concept  specializes  a given general concept
Dictionary Basis: the stat e of being categorized  [MWU]
Example: The general concept ‘high-end customer ’ specializes the general concept ‘customer .’
Example: The general concept ‘points rental ’ specializes the general concept ‘rental .’ 
Example: The general concept ‘airport branch ’ specializes the general concept ‘branch .’ 
Note: For more discussion and examples see: Annex B.2.1, I.2, C.5, C.6, as well as the EU-Rent 
examples in Annex G.

Semantics of Business Vocabula ry and Business Rules, v1.3        81categorization scheme
Definition: scheme for partitioning things  in the extension  of a given  general concept  into the 
extensions  of categories  of that general concept
Example: The general concept  ‘person ’ categorized by age range an d gender into categories ‘boy ’, 
‘girl’’ ‘man ’, ‘woman ’.
Dictionary Basis: an orderly combination of related parts  [AH (3) ‘scheme’]  
categorization scheme  is for general concept
Definition: the general concept  is divided into category (s) by the categorization scheme  
Necessity: Each categorization scheme  is for  at least one general concept .
Synonymous Form: general concept  has categorization scheme
categorization scheme  contains category
Definition: the category  is included in the categorization scheme  as one of the categories divided into 
by the scheme 
Synonymous Form: category  is included in categorization scheme
Concept Type: partitive verb conce pt
Necessity: Each category  that is included in  a categorization scheme  that is for a general concept  
is a category  of that general concept .
segmentation
Definition: categorization scheme  whose contained categories  are complete (total ) and disjoint with 
respect to the general concept  that has the categori zation scheme
Synonym: partitioning
partitioning
See: segmentation
concept type                                                                                                                                                                          FL
Definition: general concept  that specializes  the concept  ‘concept ’
Note: A concept  is related to a concept type  by being an instance  of the concept type .
Example: verb concept , role, concept type
categorization type
Definition: conce pt type  whose instances  are always categories  of a given  concept   
Note: A categorization type  is either partial or complete.  It is  complete if it necessarily categorizes 
everything of the general concept that it is for.
Example: EU-Rent’s categorization type for EU-Rent’s concept of ‘branch’ whose instances are 
categories of branch:  ‘airport branch’, ‘agency’, and ‘city branch’.
categorization type  is for general concept
Synonymous Form: general concept  has categorization type
characteristic type
Source: ISO 1087-1 (English)  (3.2.5) [‘type of characteristics ’] 
Definition: category of [the concept] ‘characteristic ’ which serves as a criterion of subdivision when 
establishing concept systems
82                 Semantics of Business Vocabulary and Business Rules, v1.3General Concept: categorization type
Necessity: Each instance  of each characteristic type  is a characteristic .
Example: The extension of the characteristic type  ‘color ’ includes the characteristics ‘thing  is blue’, 
‘thing  is red’, ‘thing  is green’ etc.
Real-world Numerical Correspondence
Definition: the categorization scheme  of the concept  ‘concept ’ that  classifies  a concept  based on 
whether or not the concept  always corresponds to one specific real-world individual
Necessity: The concept  ‘individual noun concept ’ is included in Real-world Numerical 
Correspondence .
Necessity: The concept  ‘general concept ’ is included in Real-world Numeri cal Correspondence .
14.2.2 Classification
Figure 14.4 - Classification
classification
Definition: proposition  that the  instance  of a given individual noun concept  is an instance  of a 
given general concept
Dictionary Basis: to place in the same group with  others : associate in a class  [MWU (3) “assort”]
Example: The individual noun concept ‘ Euro’ specializes the general concept ‘currency ’
Example: The individual noun concept ‘ Ford Motor Company ’ specializes the general concept ‘car  
manufacturer ’

Semantics of Business Vocabula ry and Business Rules, v1.3        83Example: The individual noun concept ‘ Switzerland ’ specializes the general concept ‘country ’
Synonym: assortment
Note: For more discussion and examples see: Anne x B.3.5, as well as the EU-Rent examples in 
Annex G.
assortment
See: classification
14.2.3 Characterization
Figure 14.5 - Characterization
characterization
Definition: proposition  that a given  concept  incorporates a given characteristic
Dictionary Basis: to describe the essential character or quality of [MWU (2) “characterize”]
Example: The proposition that the concept ‘authorized driver ’ incorporates the ch aracteristic ‘person  is 
licensed’
Example: The proposition that the concept ‘ Eiffel Tower ’ incorporates the ch aracteristic ‘structure
is quadrilateral’

84                 Semantics of Business Vocabulary and Business Rules, v1.314.2.4 Verb Concept Objectifications
Figure 14.6 - Verb Concept Objectification
verb concept objectification
Definition: general concept  that objectifies  a given  verb concept
Concept Type: role
objectified verb concept
Definition: verb concept  that is objectified by  a given  general concept
Concept Type: role
general concept  objectifies  verb concept
Definition: the general concept  incorporates  each  characteristic  that is incorporated by  the verb 
concept  and the  general concept  incorporates  no characteristic  that is not incorporated 
by the verb concept
Synonymous Form: verb concept  has verb concept objectification
Synonymous Form: general concept  has objectified verb concept
Necessity: Each  verb concept  is objectified by  at most one  general concept .
Necessity: Each  general concept  that objectifies  a verb concept  is coextensive with  the verb 
concept .

Semantics of Business Vocabula ry and Business Rules, v1.3        85Example: The general concept ‘sponsorship’ objectifies the verb concept ‘company  sponsors 
publication ’.  Each sponsorship is an actuality that a given company sponsors a given 
publication.
Note: See Annex I.4.4 and Annex C.9 for additional discussion.
14.3 Contextualization
14.3.1 Context of Thing
Figure 14.7 - Contextualization
fundamental concept
Definition: general concept  whose real-world indivi duals are perceived by a given  semantic  
community  as being in their essence, apart from any situation  in which they are involved or 
viewpoint  from which they are considered 
Dictionary Basis: a property or group of properties of some thing without which it would not exist or be what it is 
[NODE ‘essence’]
Concept Type: concept type
Example: car (as contrast ed with ‘rental car’)

86                 Semantics of Business Vocabulary and Business Rules, v1.3Example: person (as contrasted with ‘customer’)
Note: Each semantic community decides what is within its body of shared meanings. A concept that 
is considered as fundamental by  one community may, to another community, be a role or facet 
or category of a more broadly-defined concept.
contextualized concept
Definition: role or facet
General Concept: noun concept
Context of Thing
Definition: the segmentation  of the concept  ‘noun concept ’ that  classifies  a noun concept  based 
on whether the noun concept ’s real-world individual s are perceived by the semantic  
community  as in their uninvolved essence or as to their involvement in a situation  or from a 
viewpoint
Necessity: The concept  ‘fundamental concept ’ is included in  Context of Thing .
Necessity: The concept  ‘contextualized concept ’ is included in Context of Thing .
Semantics of Business Vocabula ry and Business Rules, v1.3        8714.3.2 Situations
Figure 14.8 - Situations
situation
Definition: state of aff airs that is a set of circumstances that provides the context from which roles  
played may be understood or assessed
Dictionary Basis: a set of circumstances in which one finds oneself;  a state of affairs [NODE ‘situation’]
Dictionary Basis: the circumstances that form the setting for an event, statement, or idea, and in terms of which it 
can be fully understood or assessed [NODE ‘context’]
Note: A situation typically pertains for some period of time, during which changes may occur. 
Example: The situation ‘breakdown du ring rental’ is the set of circum stances that starts with the 
breakdown of a car while on rental and continues until the broken-down car, having been replaced by another car, has been returned to a EU-Rent location.

88                 Semantics of Business Vocabulary and Business Rules, v1.3is-role-of proposition
Definition: proposition  that a given role ranges over a given general concept  in some  situation
Example: The role ‘replacement car ’ in the situation of a breakdown  during a rental ranges over the 
general concept ‘rental car ’ 
Example: The role ‘pick-up branch ’ in the situation of a rental rang es over the general concept ‘branch ’ 
Note: For more discussion and examples see: Annex B.3.2, C.5, as well as the EU-Rent examples in 
Annex G.
situational role
Definition: general concept  that corresponds  to things  being in some  situation , such as playing a 
part, assuming a function, or being used in some circumstances
General Concept: general concept , role
Concept Type: concept type
14.3.3 Facets
Figure 14.9 - Facets

Semantics of Business Vocabula ry and Business Rules, v1.3        89is-facet-of proposition
Definition: proposition  that a given concept  has a given facet  
Example: The concept ‘rental car ’ has the facet ‘asset ’ from the viewpoint of financial accounting.  
Example: The concept ‘person ’ has the facet ‘driver ’ from the viewpoint of car rental.
Note: A given community may choose to include any number of facets,  including just one or none at 
all.
Note: For more discussion and examples see: Anne x B.3.3, as well as the EU-Rent examples in 
Annex G.
facet
Definition: concept  that   generalizes a given  concept   but incorporates only those characteristics  that 
are relevant to a particular viewpoint
General Concept: contextualized concept
Dictionary Basis: a particular way in which some thing ma y be considered; its particular nature, appearance, or 
quality; the particular part or feature of it [NODE ‘aspect’]
Synonym: aspect
aspect
See: facet
viewpoint
Definition: perspective from which something is considered
concept has facet
Definition: the facet  generalizes  the concept  and incorporates  only those characteristics  that are 
relevant to a particular viewpoint
90                 Semantics of Business Vocabulary and Business Rules, v1.314.4 Elements of Conc ept System Structure
Figure 14.10 - The Elements of Concept System Structure

Semantics of Business Vocabula ry and Business Rules, v1.3        91Elements of Concept System Structure
Definition: the categorization scheme  of the concept  ‘meaning ’ that  classifies  a meaning  based on 
its part in organizing a community’s concept system
Necessity: The concept  ‘association ’ is included in Elements of Concep t System Structure .
Necessity: The concept  ‘property association ’ is included in Elements of Concep t System Structure .
Necessity: The concept  ‘characteristic ’ is included in Elements of Concep t System Structure .
Necessity: The concept  ‘partitive verb concept ’ is included in Elements of Concep t System Structure .
Necessity: The concept  ‘categorization ’ is included in Elements of Concept System Structure .
Necessity: The concept  ‘classification ’ is included in Elements of Concep t System Structure .
Necessity: The concept  ‘characterization ’ is included in Elements of Concept System Structure .
Necessity: The concept  ‘is-role-of-proposition ’ is included in Elements of Concep t System Structure .
Necessity: The concept  ‘is-facet-of-proposition ’ is included in Elements of Concept System Structure .
Necessity: The concept  ‘verb concept objectification ’ is included in  Elements of Concept System  
Structure .
14.5 Conceptua lization Choices
Figure 14.11 - Kinds of Conceptualization Choice

92                 Semantics of Business Vocabulary and Business Rules, v1.3concept of thing as unitary
Definition: concept  that conceptualizes its instances  as not being made up of discrete parts or elements 
Note: A thing is conceptualized as unitary if a se mantic community doesn’t think of it as having 
components, even though some  other community may be aware of and concerned about its 
decomposition.
Example: EU-Rent finance department treats a car as  unitary, while its maintenance staff treat it as 
composite.
concept of thing as composite
Definition: concept  that conceptualizes its instances  as being made of discrete parts or elements that 
have corresponding concepts  in their own right
Necessity: No concept of thing as unitary  is a concept of thing as composite .
concept of thing as primitive
Definition: concept  that conceptualizes its instances  as not being developed or derived from anything 
else
Dictionary Basis: not developed or  derived from anything else  [NODE ‘primitive’]
concept of thing as developed
Definition: concept  that conceptualizes its instances  as being developed or derived from something else
Necessity: No concept of thing as primitive  is a concept of thing as developed .
concept of thing as occurrent
Definition: concept  that conceptualizes its instances  as existing only at a point in time
Dictionary Basis: the fact of somethi ng existing or being found in a place or under a particular set of conditions  
[NODE ‘occurrence’ 2] + the fact or frequency of something happening  [NODE ‘occurrence’ 1]
concept of thing as continuant
Definition: concept  that conceptualizes its instances  as existing over a period of time
Dictionary Basis: a thing that retains its identity even though its states and relations may change.  [NODE 
‘continuant’ 2]
Necessity: No concept of thing as occurrent  is a concept of thing as continuant .
concept of thing existing independently
Definition: concept  that conceptualizes each  instance  to exist independently of other things  such that 
existence cannot be ended by the ending of the existence of any other thing
concept of thing existing dependently
Definition: concept  that conceptualizes each  instance  as existing only as long as one or more other 
things  continue to exist
Necessity: No concept of thing existing independently  is a concept of thing existing dependently .
Semantics of Business Vocabula ry and Business Rules, v1.3        9315 Elementary Concepts
15.1 Introduction
Figure 15.1 - Quantities, Numbers, and Sets
15.2 Quantities
quantity  
Definition: aspect in which a thing  is measurable in terms of greater, less, or equal [MWU]
General Concept: noun concept
Note: The concept quantity  can be elaborated into mathematical systems, such  as integers and real 
numbers, and into systems of measures. This specification elaborates only the concepts for 
integer, because they are comm only used in structural rules.  For measurement systems and 

94  Semantics of Business Vocabulary and Business Rules, v1.3units of measure there are accep ted vocabularies and perhaps standard ontologies, but the 
specification of such a vocabulary is beyond the scope of this specification. 
quantity1 equals quantity2
Definition: the quantity1 is mathematically equivalent to the quantity2 
Synonymous Form: quantity1 is equal to quantity2
quantity1 is less than quantity2
Definition: the quantity1 is mathematically less than the quantity2 
Synonymous Form: quantity2 is greater than  quantity1
15.3 Numbers
number  
Definition: quantity  belonging to an abstract mathematical system and subject to laws of succession, 
addition, and multiplication
Dictionary Basis: An arithm etical value, expressed by a word, sym bol, or figure, representing a particular 
quantity and used in count ing and making calculations [ODE: “number,” 1]
Note: The ISO 6093 Number Namespace  has designations for decimal numbers.
integer  FL
Definition: number  that has no fractional part
 nonnegative integer  FL
Definition: integer  that is greater than  or equal to  zero
positive integer  FL
Definition: nonnegative integer  that is not equal to  zero
15.4 Sets
set FL
Definition: collection of zero or more things  considered together without regard to order or repetition
thing  is in set FL
Definition: the thing  is a member of the set
Synonymous Form: set includes thing
Synonymous Form: set has element
element  
Concept Type: role
Definition: thing  that is in a set
 cardinality  FL
Definition: nonnegative integer  that is the number  of distinct elements  in a given  set or collection
Concept Type: role
Semantics of Business Vocabula ry and Business Rules, v1.3        95Note: The means of distinguishing things as elements  of a set is dependent on the kind of thing and 
the viewpoint taken in constructi ng each kind of set. Reference schemes may be used in this 
regard.
set has cardinality                                                                                                                                                               FL
Definition: the cardinality  is the number of distinct elements in the set
Necessity: Each  set has at most one  cardinality .
96                                                         Semantics of Business Vocabulary and Business Rules, v1.3
Semantics of Business Vocabula ry and Business Rules, v1.3        9716 Business Rules
16.1 Elements of Guidance
16.1.1 Introduction
The common sense  understanding of ‘rule’ is that  a rule always tends to remove some degree of freedom.  This common sense  
understanding should be contrasted with that for ‘advice’, wh ere a degree of freedom is neve r removed, even potentially. 
The degree of freedom removed by a rule might concern the behavior  of people (in the case of an operative business rule), or 
their understanding of concepts (in the case of a structural rule ).  In the latter case, the restricting of freedom is built-in  (i.e., 
“structural” or “by definition”).  In the former case, people can still potentially violate or ignore the rule - that is a matt er of 
free will, appropriate enfo rcement, and sometimes discretion (for example if the rule is of fered simply as a guideline or 
suggestion).
Nonetheless, an operative business rule always mandates or suggests some out-of-bounds criteria for behavior, thereby 
potentially removing a degree of freedom.  For example, the meaning of  “It is prohibited that an order be paid by promissory 
note” indicates that workers are not completely free to accept IOUs  for payment of orders.  That  particular degree of freedom 
has been removed or diminished.  Depending on enforcement leve l, violating the rule could well invite response, which might 
be anything from immediate prevention and/ or severe sanction, to mild tutelage.  No te that other degrees of freedom have not 
been removed or diminished by this particular rule.  For exam ple, unless other rules pertain to how orders are paid, workers 
are free to accept cash, credit cards, or othe r means of payment - those means are allo wed.  The general implication is that 
rules indirectly prescribe what is allowable - whatever the rules do not  specifically proscribe is allowed.
An advice is just the opposite of a rule.  Whereas a rule always poten tially removes some degree of  freedom, an advice always 
confirms or reminds that some degree of freedom does exist or is  allowed.  That degree of freedom might concern the behavior 
of people (in the case of an operative business rule), or their understanding of concepts (in the case of a structural rule). 
It might be helpful to think of an advice as  an ‘un-rule’ or ‘no-rule’.  For example, the meaning of “It is permitted that an o rder 
be paid by cash” is that such behavior is  allowed - that indeed, paying by cash is acceptable.  In other wo rds, there is (or sh ould 
be) no rule to the contrary. 
Since an advice never removes degrees of freedom, why is it so metimes useful to capture?  Th ere are many possible reasons, 
but probably foremost among them are to re-assure workers or othe rs that some degree of freedom does exist; to use as a basis 
for admonishing workers about applying some rule that actually does not exist; or to ‘remember’ the resolutions to some rule-
related issue where the outcome  was in favor of ‘no rule’.
98                 Semantics of Business Vocabulary and Business Rules, v1.3Figure 16.1 - Kinds of Element of Guidance
16.1.2 Business Rules and Advices
business rule
Definition: rule that  is under business jurisdiction
General Concept: rule, element of guidance
Note: A rule’s being under business jurisdiction means that it is under the jurisdiction of an authority 
that can opt to change or discard the rule at its  own discretion. Laws of physics may be relevant 
to a company; legislation and regulations may be imposed on it; external standards and best practices (other than business rules) may be relied upon. These things are not business rules 
from the company’s perspective,  since it does not have the standing to change them. The 
company will decide how to r eact to laws and regulations, an d will create or adopt business 
rules to ensure compliance with the laws and regulations. Similarly, it will create or adopt business rules to ensure that standards or be st practices (other than business rules) are 
implemented as intended . See sub clause A.2.3.
Note: See sub clause E.2.3 and the OMG’s Business Motivation Model 
[BMM] , which shares the 
concepts ‘business policy’ and ‘business rule’ with SBVR. In the BMM, business policy and 
business rule are kinds of directive, and regu lation is a kind of influencer. Influencers are 
related indirectly to directives, via potential  impact and assessment.  This supports stake 
holders of the business in identifying the imp acts of influencers on the business and then 

Semantics of Business Vocabula ry and Business Rules, v1.3        99assessing what directives are needed to deal  with these impacts. The enterprise BMM can 
provide information on earlier, relevant assessme nts, the directives that were created or 
changed, the courses of action that were adop ted, and the desired results (which can be 
compared with actual result s if they are available).
There is also a special relation ship between directive and regula tion - that a directive from an 
authoritative source within an enterprise may be treated like a regulation by other organization units in the enterprise. For example, if the H ealth and Safety Unit of a business issued a 
directive about safe handling of products and materials, other organization units (such as 
Manufacturing, Warehousing and Distribution) woul d treat it as a regula tion, in that they 
would have to comply with it in  an acceptable way, although thei r assessments of its impact on 
their operations and thei r decisions on compliance might well be different.
element of guidance  is practicable
Concept Type: characteristic
Definition: the element of guidance  is sufficiently detailed and precise that a person who knows the 
element of guidance  can apply it effectively and consiste ntly in relevant circumstances to 
know what behavior is acceptable or not, or how something is understood
Dictionary Basis: able to be done or put into  practice successfully; able to be used, useful [ODE]
Note: The sense intended is:  “It’s actually something you can put to use or apply.”Note: The behavior, decision, or calculation can be that person’s own.Note: Whether or not some elemen t of guidance is practicable is decided with respect to what a 
person with legitimate need can understand from it.
• For an operative business rule, this understanding is about the behavior of people and what form compliant behavior takes.
• For a structural rule, this understanding is ab out how evaluation of th e criteria vested in 
the rule always produces some  certain outcome(s) for a decisi on or calculation as opposed 
to others.
Note: A practicable business rule is also always fr ee of any indefinite reference to people (e.g., 
“you,” “me”), places (e.g., “here”), and time (e.g ., “now”).  By that means, if the person is 
displaced in place and/or time fr om the author(s) of the busines s rule, the person can read it 
and still fully understand it, without (a) assistan ce from any machine (e.g.,  to “tell” time), and 
(b) external clarification.
business rule  is derived from business policy
Synonymous Form: business policy  is basis for business rule
advice
Definition: element of guidance  that is practicable  and that  is a claim of permission  or of possibility
Necessity: No business policy  is an advice .
Necessity: No business rule  is an advice .
Synonym: business advice of perm ission or possibility
advice  is derived from  business policy
Synonymous Form: business policy  is basis for advice
100                 Semantics of Business Vocabulary and Business Rules, v1.316.1.3 Elements of Governance
element of governance
Definition: element of guidance  that is concerned with directly controlling, influencing, or regulating 
the actions of an enterp rise and the people in it
Dictionary Basis: conduct the policy, actions, and affairs of  (a state, organization, or people) with authority: 
control, influence, or regulate (a person, action, or course of events) [ODE, “govern”]
element of governance  is directly enforceable
Definition: violations of the element of governance  can be detected withou t the need for additional 
interpretation of the elem ent of governance  
Concept Type: characteristic
Note: ‘Directly enforceable’ mean s that a person who knows about the element of governance could 
observe relevant business activity (including his or her own behavior) and decide directly whether or not the business was comply ing with the element of governance.
Necessity: Each  element of governance
 that is directly enforceable is practicable .
business policy
Definition: element of governance  that  is not directly enforceable  whose purpose is to guide an 
enterprise
Note: Compared to a Business Rule, a Business Policy tends to be:
  -  less structured
  -  less discrete or not atomic
  -  less carefully expressed in  terms of a standard vocabulary
  -  not directly enforceable.
Dictionary Basis: definite course or method of action se lected (as by a government, institution, group, or 
individual) from among alternatives and in the light of given conditions to guide and usually 
determine present a nd future decisions [MWUD “Policy” 5a]
Necessity: No business policy  is a business rule .
Example: The policy expressed as “A prisoner is consid ered to be on a hunger strike after missing several 
meals in a row.”
Example: The policy expressed as “The prison medical authority will intervene if a hunger striker’s life 
is in danger.”
Example: The EU-Rent policy expressed as  “Rental cars must not be exported.”
Example: The policy expressed as “Each customer wh o complains will be pers onally contacted by a 
representative of the company.”
16.2 Element of Guidance Statements
The surface syntax people use to express guid ance is language-specific.  It is also de pendent on the particular rule language 
(e.g., SBVR Structured English, RuleSpeak , ORM, etc.).  This clause does not st andardize any particular rule language.  
Instead, it provides a normative vocabulary for the kinds of guida nce statements that business pe ople assert.  These kinds of 
guidance statements are general with respect to any particular language.
The categories presented in this  sub clause are intended for business people. Business people see and hear surface syntax.  
Therefore, the categories defined in sub cl auses 17.2 and 18.2 are based on form or st yle of expression.  For example, if a 
Semantics of Business Vocabula ry and Business Rules, v1.3        101business person says “It is obligatory that not p,” the form or style of the expression remains an obligation statement. That 
interpretation reflects the ‘com mon sense’ of the statement.
This emphasis on form or style of expression distinguishes this sub clause from Clause 24, which provides deeper logical 
analysis.  For example, if a business person  says “It is obligatory that not p,” logical analysis following Clause 24 takes the  
meaning of the expression to be a prohibition (which might not be “common sense”). The key to distinguishing the perspective 
of this sub clause from the logi cal analysis of Clause 24 is emphasized by the unfailing use of “statement” in the names of the  
concepts for element of guidance statements.  When “statement” appears in Clause s 16, 17, and 18, it is  always the case that 
the concept so named refers to the styl e and form of surface expression, rather than underlying mean ing based on logical 
analysis.
Figure 16.2 - Guidance Statement and Kinds of Guidance Statement
guidance statement
Definition: statement  that  expresses  an element of guidance  
Definition: statement  that provides advice or information aimed at resolving a problem or difficulty, 
especially as given by  someone in authority 
Dictionary Basis: a statement that provides advice or information aimed at resolving a problem or difficulty, 
especially as given by  someone in authority [NODE ‘guidance’]
Kind of Guidance Statement
Definition: the categorization scheme  of the concept  ‘guidance statement ’ that classifies  a 
guidance statement  based on  the surface syntax of the guidance statement
business policy statement
Definition: guidance statement  that  expresses  a business policy  

102                 Semantics of Business Vocabulary and Business Rules, v1.3Necessity: The concept  ‘business policy statement ’ is included in  Kind of Guidance Statement .
rule statement
Definition: guidance statement  that expresses an operative business rule  or a structural rule
Necessity: The concept  ‘rule statement ’ is included in  Kind of Guidance Statement .
advice statement
Definition: guidance statement  that expresses  an advice of permission  or an advice of possibility  
Necessity: The concept  ‘advice statement ’ is included in  Kind of Guidance Statement .
16.3 Fundamental Principles for Elements of Guidance
16.3.1 The Severability Principle
Principle:  The meaning of an element of guidance may be expressed separately from any other element of guidance; 
nonetheless, a body of shared guidance that  includes the element of guidance will be evaluated as if all the elements of 
guidance had been expressed jointly and all had to hold true.
In everyday business, elements of guidan ce are individual elements of meaning that exist separately .  Often, they are also 
expressed separately – e.g., by individual sentences.  In a b ody of shared guidance of any size, such separate expression of 
dissimilar or disjoint elements of guidance is a practical necessity  for readability and manageability.
In SBVR, a body of shared guidan ce is nonetheless logically consid ered as a whole.  In other words, each element of guidance 
is always applied in all situations where th at element of guidance is relevant – even if expressed separately . This is true eve n if 
the element of guidance is expressed without direct reference to  related elements of guidance that are relevant for the same 
situation.
This fundamental understanding is called the Severability Principle .1  
The MWUD definition of  “severable” is:  
capable of being severed … ;  especially   : capable of be ing divided into legally independent rights or obligations   
used of a statute or contract of which the part to be performed consists of distinct items to which the consideration 
may be apportioned so that the invalidity or failure of performance as to  one item does not necessarily affect the 
others
This captures the sense of what SBVR mean s by ‘severable’.  If one element of gui dance is invalidated or violated somehow, 
the rest still apply.
It should be noted that expressing elements of guidance separa tely and without reference to related elements of guidance may 
increase the chance of conflicts, but does not create it per se. Ev en a single element of guidance can have internal conflicts.  
Conflicts must be resolved by proper specification, including cases where exceptio ns are intended, as discussed in 16.4.
It should also be noted that the Severability Principle  does not apply across separate bod ies of shared guidance. Therefore 
conflicts and exceptions, as discussed in 16.4, can only exist with in a single body of shared guidance. They cannot exist acros s 
two or more bodies of shared guidance.
1. This SBVR principle is the busi ness counterpart to what in propos itional logic is often called the universal ‘and’. This assumption 
requires that all separate Propositions be true (for a body of shar ed guidance). Therefore, an implicit ‘ and’ must be considered to exist 
between all such Propositions. 
Semantics of Business Vocabula ry and Business Rules, v1.3        10316.3.2 The Accommodation Principle
Principle:  An element of guidance whose mean ing conflicts with some other element(s) of guidance must be taken that way;  if 
no conflict is intended, the element( s) of guidance must be expressed in such a way as to avoid the conflict.
Exceptions to elements of guidance must be  accommodated explicitly; that is, cases where exceptions to elements of guidance 
are intended must be worded in such a wa y to avoid any confli ct in the meanings.
In SBVR, statements can mean only what the actual words presented in the statem ents indicate they mean. Therefore, to 
indicate that an exception is intended always requi res additional or altern ative specification (i.e., accommodation ).  Otherwise 
the meanings of the statements would simply (and necessarily) be taken to be in conflict. 
16.3.3 The Wholeness Principle
Principle:  An element of guidan ce means only exactly what it says , so it must say everything it means.
Each element of guidance must be  self-contained; that is, no need to appeal to  any other element(s) of  guidance should ever 
arise in understanding the full meaning of a given element of guidance.
The full impact of an element of guidance for a body of shared guidance, of course, cannot be understood in isolation.  For 
example, an element of guidance might be in conflict with another element of guid ance, or act as an aut horization in the body 
of shared guidance.  The Wholeness Principle  simply means that if a body of shared guidance is deemed free of conflicts, then 
with respect to gu idance, the full meaning  of each element of guidance does not requ ire examination of a ny other element of 
guidance. In other words,  each element of guidance can be taken at face value for whatever it says.
16.4 Accommodations, Exce ptions, and Authorizations
16.4.1 Authorizations
SBVR makes a ‘light world’2 assumption about rules.  In a light world , anything that is not expressly prohibited is assumed 
permitted, and anything not expressly declared as impossible is assumed possible. Business rule practice indicates that this 
choice is the appropriate one for the large majority of business problems.
Occasionally, practitioners may discover ‘dar k areas in a light world’ – areas in wh ich the opposite assump tion is appropriate.   
In such a dark area , anything not expressly permitted is assumed prohibited , or anything not expressly declared as possible is 
assumed impossible.  Dark areas of the former kind – the more important and common of the two cases – might involve use of, 
and/or access to, resources that are deemed especially sensitive, dangerous, scarce, and/ or valuable. For that reason, it makes  
sense to grant permission for use an d/or access explicitly. Such permissions  are often called ‘authorizations’.
In everyday business language, an authorization  is generally understood to mean a sanction or a warrant [MWUD]. 
[MWUD “sanction” noun]: 6a. explicit permission or recogniti on by one in authority that gives validity to the act of 
another person or body 
[MWUD “warrant” noun]: 2a. a commission or document givi ng authority to do something : an act, instrument, or 
obligation by which one person authorizes another to do so mething which he has not otherwise a right to do and thus 
secures him from loss or damage
2.  Ronald G. Ross, “The Light World vs. the Dark World ~ Busine ss Rules for Authorization,” Busi ness Rules Journal, V ol. 5, No.  8 
(August 2004), URL:  http://www .BRCommunity.com/a2004/b201.html
104                 Semantics of Business Vocabulary and Business Rules, v1.3For SBVR, it is important to note that an authorization is explicit  (from “sanction”), and that without it, there is not otherwise 
a right to do something  (from “warrant”).  
16.4.2 Exceptions
Authorizations fall under the more general topic of exception .  In everyday business language, to ‘make an exception’ is 
generally understood to mean [M WUD “exception” 1] “the act of  excepting or excluding: exclusion or restriction (as of a 
class, statement, or rule) by taking out something that would othe rwise be included.”  An ‘excep tion’ is what is omitted from 
consideration.
In SBVR, the Severability Principle  permits elements of guidance to be given separately (individually), raising the possibility 
that one element of guidance might actually be intended as an  exception with respect to anot her. The general element of 
guidance and its exceptions are always in the same body of shared guidance.
SBVR’s approach to exceptions, which in cludes authorizations, is based on the f undamental principles for elements of 
guidance given in sub clause 16.3.  The following describes how exceptions and authorizations may be specified in SBVR.
16.4.3 Approaches to Capturing Accomm odations, Exceptions, and Authorizations
Approach 1 – General Elements of Guidance that Accommodate More Specific Cases
This approach uses the verb concepts speci fied in sub clause 8.6.3 to allow for more  specific cases to be specified for some 
more general element of guidance.  This discussion will use the ‘element of guidance  authorizes  state of affairs ’ verb 
concept, but it should be noted that the other two verb con cepts would be applied similarly, as appropriate to the business 
situation.
A state of affairs being ‘authorized’ means that some specific element of guidance in a body of shared guidance entails that th e 
state of affairs may validly occur, i.e., is  not an error or conflict with the more general rule.  Support for exceptions (and 
authorizations) in this appro ach is accomplished as follows.  
• An operative business rule is specified  to declare that some given area of bu siness activity is prohibited except where 
there is some explicit advice of permissi on given (i.e., a ‘dark’ area is declared).
• Explicit advice(s) of permission, qualif ied as appropriate, are specified to decl are selective exceptions/authorizations. 
Without such permissions, there would otherwise be no right to do something.
In general, a logical OR  is always assumed between the more specific cases given separately from the more general element of 
guidance. The body of shared gu idance can contain any number of ‘exceptions’ to  general cases without introducing conflicts 
as long as the general case elemen t of guidance allows for exceptions.
Semantics of Business Vocabula ry and Business Rules, v1.3  10 5The two Examples illustrate different subject s for authorization. The first authorizes an action (use of a vehicle on an ice road) 
under given conditions, whereas the second authorizes people to carry out an action (making a payment).
EXAMPLE
Two guidance statements, expressing a general rule and a more specific case for EU-Rent:  
Vehicle Usage Rule
A vehicle  may  use an ice road  only if the  use is authorized by  a Vehicle Usage Advice .
Arctic Circle Exemption
Any ice road  that is north of the Arctic Circle  may  be used by  any vehicle .
The Arctic Circle Exemption  is a Vehicle Usage Advice .
These elements of guidance work together like this:  
The first element (an operative business rule) sets up the dark area , prohibiting 
any use that is not explicit ly authorized.  It does this  by use of the verb concept 
‘element of guidance  authorizes  state of affairs ’. 
The second element is one of perh aps many Vehicle Usage Advices. The  
concept ‘Vehicle Usage Advice’ is a category of advices within EU-Rent’s  
body of shared guidance.
Note that this Example assumes the standard SB VR constructs have been used, e.g., ‘vehicle ’ and ‘ice road ’ are assumed to 
be defined terms; as well as the verb concept (vehicle  uses ice road ) being defined and objectified as ‘use ’.  For simplicity, 
‘being north of the Arctic Circle’ is taken to be a characteris tic of an ice road, but other, more elaborate solutions could have 
been worked out.
106                 Semantics of Business Vocabulary and Business Rules, v1.3Approach 2 – Using a Business Concept
Another acceptable approach , illustrated below by a reworki ng of the second Example given fo r Approach 1, is that the 
business has some concept(s) to help express authorizations.EXAMPLE
Three guidance statements, expre ssing a general case and two more specific cases, with facts that classify the specific cases 
and connect them to the general case: 
Guidance Statements: 
Payments Business Rule
A person  may make  a payment  only if a  Payment Authorization  authorizes  that the  person  make  the  
          payment .
Senior Manager Exemption
Any senior manager  may make  any payment .
Jane Smith  may make  any payment .
 
Facts:
The Senior Manager Exemption  is a Payment Authorization .
“Jane Smith  may make  any payment ” is a Payment Authorization .
The first element (an operative business rule) sets up the dark area , prohibiting any payment that is not explicitly 
authorized.  The verb concept used is ‘ element of guidance  authorizes  state of affairs ’.
The second element is a bl anket advice of permission that allows any person who is a senior manager to make a payment.  
The third element stipulates that a specifi c person (Jane Smith) may make payments.
This Example assumes the de fined verb concept ‘person  makes  payment ’.  It also assumes that the terms used are defined 
(e.g., person , payment ) and that Jane Smith is a known person (and no assumption beyond that is made about her). The two 
facts classify the second and th ird elements as ‘Payment Author izations’, a category of advices of permission in the body of 
shared guidance, and thus relate them to the general case, in which ‘Payment Au thorization’ plays a role.
Regarding any person and payment, the exception condition  of the rule statement is that the person be explicitly permitted to 
make the payment, either directly (as in the case of Jane Smith) or indirectly (as in the case of any senior manager).  The 
advice of permission statements express, for certain persons and any payment,  that a person is permitted to make the 
payment.  It can be determined, for ev ery instance of the ve rb concept ‘person  makes  payment ’, that the condition is 
satisfied.  As long as a person satisfies either exception condition  of the rule, that person is permitted to make any payment 
– i.e., that he or she has ‘authorization’.
Semantics of Business Vocabula ry and Business Rules, v1.3        107Approach 3 – Formulating Elements of Guidance to Avoid Exceptions
A third approach is to simply specify a set of elements of guidance whose conditions are mutually-exclusive.  EXAMPLE
Consider the following rule and supporting statements that use the concept ‘ authorized payer ’, which has been defined as 
“person  that may  make  any payment ”.
    Rule Statement:  Only an  authorized payer  may  make  a payment .
    Specification of Authorized Payers:
• Each  senior manager  is an authorized payer .
• Jane Smith  is an authorized payer .
Given the definition of ‘authorized payer ’, these two statements meet the sa me business requirement as the advice 
statements in the second Example given fo r Approach 1 – that senior managers and Jane Smith may make any payment.  
Regardless of the definition of ‘authorized payer’, these two st atements clearly satisfy the condi tion of the rule statement by  
identifying instances of ‘authorized payer ’, which is the concept consider ed by the condition in the rule.
EXAMPLE
Two rules, expressed as individual statem ents with mutually-exclusive conditions:  
1.The state sales tax  must  be charged on  each  order  shipped within the state .
2.The state sales tax  must not  be charged on  an order  shipped out-of-state .
Note that the second rule above would not be considered to be “an exception” to the first. Rather, its expression includes 
“out-of-state” to differentiate it from or ders shipped “within the state”. This acco mmodation avoids a collision between the 
meanings of the rules th at would otherwise arise.
108                 Semantics of Business Vocabulary and Business Rules, v1.3
Semantics of Business Vocabula ry and Business Rules, v1.3        10917 Definitional Guidance
17.1 Definitional Elements of Guidance
17.1.1 Introduction
Figure 17.1 - Kinds of Definitional Elements of Guidance
17.1.2 Definitional Rules
structural rule
Definition: rule that is a claim of necessity
Synonym: definitional rule
definitional rule
See: structural rule
structural business rule
Definition: structural rule  that is a business rule  
Necessity: Each  structural business rule  is practicable .
Synonym: definitional business rule

110                                                                                        Semantics of Business Vocabulary and Business Rules, v1.3definitional business rule
See: structural business rule
17.1.3 Definitional Advices
advice of possibility
Definition: advice  that  is a claim of possibility
Note: Every necessity implies a possibility. So if a necessity is introduced by a structural rule, there 
is no practical reason to introduce the implied po ssibility. In such cases, best practice generally 
favors keeping the number of elements of guidance to be managed to a minimum. 
Example: (In a bank) The element of guidance that “It is possible that an account balance is negative.”Necessity: No advice of possibility
 is an advice of permission .
advice of contingency
Definition: advice of possibility  that  is a claim of contingency
Note: The purpose of an advice of contingency is to  preempt application of definitional “rules” that 
might be assumed to exist, but are not actually included in the body of shared guidance of the authority. Often, the reason for this assumption  in a business is that other, similar businesses 
have such rules. Typically, the reason for providing such explicit advice is that people in the business have mistakenly applied the non-existent rule in the past. 
Note: In alethic logic, a proposition that is possible but not necessary is termed ‘contingent’. If 
people in a business were to treat it as a necessi ty, they would miscategor ize things in the real 
world. This typically leads to refusal of  activity (that should be permitted) because 
unnecessary preconditions are not met, e.g., re fusing to accept a rental booking because the 
person wishing to rent is under 21. 
Example: (In EU-Rent) Advising that it is not necessary for a qualified driver to be over 21. This might 
be expressed in various ways, for example as:  “I t is neither necessary nor impossible that the 
age of a qualified dr iver is at least 21,” or  “It is poss ible (but not necessa ry) that a qualified 
driver be under 21.”
Example: (In EU-Rent) Advising that it is not necessary  for a bad experience that occurs during a rental 
to be notified before the end of the rental. This might be expressed in various ways, for example as: “It is neither necessary nor imposs ible that the notification date/time of a bad 
experience during a rental is the ac tual return date/time of the rental or earlier.” It is possible 
(but not necessary) that the notification of a ba d experience during a rental occurs after the car 
has been returned.”
Semantics of Business Vocabula ry and Business Rules, v1.3        11117.2 Definitional Elemen t of Guidance Statements
17.2.1 Statements of  Definitional Rules
Figure 17.2 - Definitional Rule Statement and Kinds of Definitional Rule Statement
structural rule statement
Definition: rule statement  that expresses  a structural rule
Note: One structural rule can be expressed as vari ous equivalent kinds of statements by introducing 
or removing negation. The following are examples  of the same rule, expressed in three forms. 
Example: [as a necessity statement ]  “It is necessary that  the pick-up branch of a one-way rental is 
not the return branch of that rental.”
Example: [as an impossibility statement ]  “It is impossible that  the pick-up branch of a one-way 
rental is the return branch of that rental.”
Example: [as a restricted possib ility statement ]  “It is possible that  the pick-up branch of a rental is 
the return branch of the rental only if the rental is not a one-way rental.”
necessity statement
Definition: structural rule statement  that is expressed positively in terms of necessity  rather than 
negatively  in terms of impossibility   
Necessity: No necessity statement  is an impossibility statement .
Necessity: No necessity statement  is a restricted possibility statement .
Example:  “It is necessary that each rental ha s exactly one requested car group.”
Example: “Each rental always has exactly one requested car group.”
impossibility statement
Definition: structural rule statement  that is expressed negatively in terms of impossibility  rather than 
positively in terms of necessity  

112                                                                                        Semantics of Business Vocabulary and Business Rules, v1.3Necessity: No impossibility statement  is a restricted possibility statement .
Example: “It is impossible that the same rent al car is owned by more than one branch.”
Example: “The same rental car is never owned by more than one branch.”
restricted possibility statement
Definition: structural rule statement  that is expressed as possibility  being acknowledged only when a 
given condition is met 
Example: “It is possible that a rental is an open rental only if the rental  car of the rental has been picked 
up.”
Example: “A rental can be an open rental only if the rental car of  the rental has been picked up.”
Note: A restricted possibility statement should not be confused with a statement of advice of 
possibility.  The latter should never contain ‘onl y’, which is always interpreted as eliminating 
or diminishing a degree of freedom (i.e., indicati ng the presence of a rule).  This inclusion of 
‘only’ is the key characteristic of restricted possibility statements.
Note: Every restricted possibility statement can  be rephrased as a conditional impossibility 
statement.  The pattern  “it is possible that p only if q” can be stated equivalently as “it is 
impossible that p if not q” or “it is not possible that p if not q” (refer to Clause 24).  For 
example, the followin g three statements mean the same thing:
1.  “It is possible that a rental is an open rent al only if the rental car of the rental has been  
   picked up.”
2.  “It is impossible that a rental is an open rental if the rental car of the rental has not been  
   picked up.”
3.  “It is not possible that a rent al is an open rental if the rent al car of the rental has not been  
   picked up.”
Semantics of Business Vocabula ry and Business Rules, v1.3        11317.2.2 Statements of Definitional Advices
Figure 17.3 - Statement of Advice of Possibility and its Kinds
statement of advice of possibility
Definition: advice statement  that  expresses  an advice of possibility  
Example: “The notification date/time of a bad experi ence that occurs during a rental can be after the 
actual return date/time of the rental.”
Necessity: No statement of advice of possibility  is a statement of adv ice of permission .
Note: One advice of possibility can be expressed as various equivalent kinds of statements by 
introducing or removing negation. The following  are examples of the same advice, expressed 
in two forms.
Example: [as a possibility statement ] “It is possible that the notifica tion date/time of a bad experience 
that occurs during a rental is after th e actual return date/time of the rental.”
Example: [as a non-necessity statement ] “It is not necessary that the notification date/time of a bad 
experience that occurs during a rental be on or before the actual return date/time of the rental.”
possibility statement
Definition: statement of advi ce of possibility  that  is expressed positively in terms of possibility  rather 
than negatively in terms of non-necessity  
Necessity: No possibility statement  is a non-necessity statement .
Example: “It is possible that the notification date/time  of a bad experience that occurs during a rental is 
after the actual return da te/time of the rental.”

114                                                                                        Semantics of Business Vocabulary and Business Rules, v1.3Example: “The notification date/time of a bad experi ence that occurs during a rental can be after the 
actual return date/time of the rental.”
non-necessity statement
Definition: statement of advice of possibility  that  is expressed negatively in terms of non-necessity   
rather than positively in terms of possibility  
Example: “It is not necessary that the notification date/time of a bad experi ence that occurs during a 
rental be on or before the actua l return date/time of the rental.”
contingency statement
Definition: statement of advice of possibility  that  expresses  an advice of contingency  
Note: A contingency statement  may take various forms, each ex pressing the meaning of the same 
advice of contingency , as illustrated by th e following examples. 
Example: “It is possible but not  necessary that a renter’s age is less than 21 years.”
Example: “It is neither impossible nor necessary that a renter’s age is less than 21 years.”
17.3 Connections between Defi nitional Rules and Concepts
Structural rules often, but not always, propose necessa ry characteristics of concepts.  Here are three cases:
1. A structural rule uses universal quantification (e.g.,  “each” or “all”) to propose a n ecessary characteristic of a 
concept.  The structural rule prop oses that something is always true  about all instances of the concept.
2. A structural rule proposes a necessary characteristic of an individual noun concept - no universal quantification is 
used because it is implicit in referring to the one and only instance of the individual noun concept.
3. Cases other than 1 and 2 above:  a structural rule does not  propose a necessary characteristic of a concept, but it 
proposes something to be necessarily tr ue.  See Rule 4 in the examples below.
A fact that a concept has a necessary charact eristic is a structural rule  that the characteristic is always true about each ins tance 
of the concept.  How is it a structural rule?  It is a proposi tion that the necessary characteristic is always true of each ins tance 
of  the concept.  Conversely, a structural  rule proposes that a characteristic is a necessary characteristic of a concept if an d only 
if the structural rule proposes that the characteristic is always  true about each instance of the concept.  The structural rule  does 
not imply that the concept incorporates th e characteristic, because necessary charact eristics can be either incorporated or 
implied.
There is a logical connection between concep ts and structural rules.  A starting point  of the logical connection is these two 
necessary truths about concepts:
1. For each concept, each characteristic  it incorporates is attributed  to each instance of the concept.
2. For each individual noun concept, the inst ance of the individual noun concept exists.
From this starting point, consider ing concepts together, there ar e any number of propositions can be proved to be true by 
logical implication.  A structural  rule is logically connected to  concepts when it proposes that one of these propositions is 
necessarily true.  Structural rule statemen ts often facilitate a deeper  understanding of concepts, but a structural rule never 
changes a concept.  Rather, it proposes what  logically follows from an understanding  of concepts, and in some cases, from 
business decisions that define specific thresholds.
In cases where definitions of concepts take n together do not logically imply something proposed in a structural rule statement,  
there is an inadequacy or mistake in either  the relevant definitions or in the rule statement.  The case of inadequate definiti ons 
Semantics of Business Vocabula ry and Business Rules, v1.3        115is common and is acceptable in some communities.  It occurs wh en a community shares a tacit understanding of many of its 
concepts.  Words either have no explicit definitions or have definitions that use words that have no explicit definitions.  
Structural rule statements in this contex t can be correct, even if th ey logically follow from a tacit understanding of what 
characteristics are inco rporated by concepts.
Practices of developing concept systems ra nge from creating highly precise, rigorously complete definitions for all concepts to  
creating no or few definitions, or largely descriptive or info rmal ones, but many structural rules.  Where highly precise, 
rigorously complete definitions ar e given there is less need for structural rule s because such rules would appear redundant.  
Where definitions are missing or unclear, or  largely descriptive or informal, structur al rules are important to sharing a commo n 
understanding of concepts.
Advices of possibility relate to concepts following the same pattern by which structural rules relate to concepts.Where there is a definition, a concept is ju st what the definition says, no more and no less.  Something called a “definition” as 
used in common speech is not nece ssarily a definition as defined by  SBVR.  It might be just a ge neral description.  It is only a 
definition if it defines the concept, differentiating it from othe rs.  As a matter of practice, a simple test for adequacy and 
correctness of definitions is to restate a rule by substituting a defin ition of a concept into a rule  statement in place of the  
concept’s designation.  Does the restatem ent express the same meaning as the origin al statement?  If not, the so-called 
definition is inadequate or incorr ect.  Consider the example below:
sports car  
Definition:  kind of car
Rule 1:  A rental of a sports car must include collision coverage.
A restatement of Rule 1, “A rental of a kind of car must include co llision coverage,” expresses a different meaning, so the 
definition is inadequate.  Here  is an adequate definition:
sports car  
Definition:  small, fast automobile equipped for racing
When the adequate definition is substituted into a restatement of the rule, the same rule is expressed.  Consider some examples  
of structural rules related to ‘sports car’.
Rule 2:  Each sports  car is always small.
Rule 2 expresses a characteristic attribut ed to all sports cars by the definition of ‘sports car’.  It is  an incorporated 
characteristic of ‘sports car’.
Rule 3:  Each Corvette is always a sports car.
Rule 3 does not change the meaning of ‘spo rts car’.  Rather, it expresses an understa nding that every Corvette is a small, fast  
automobile equipped for racing.  This understanding is found in the meaning of Corvette.  Agreement on this understanding 
might come from analysis of a definition of ‘Corvette’, or it might be established by a business decision about meaning based 
on tacit knowledge.  Structural rules expressing such busines s decisions are often important guides to business knowledge.
EU-Rent Speedway  
Definition:  the test track owned by EU-Rent where any small car is testable
Rule 4:  A test track always exists.
Rule 4 follows logically from the individual noun concept ‘EU- Rent Speedway’.  An individual noun concept always has one 
instance.  So there is always a EU-Ren t Speedway, and therefore, a test track.
Rule 5:  The EU-Rent Speedway is always in Germany.
116                                                                                        Semantics of Business Vocabulary and Business Rules, v1.3Rule 5 does not appear to follow logically from an understandi ng of definitions.  It might well be true that the EU-Rent 
Speedway is in Germany, but Rule 5 proposes that it is always true - true in all poss ible worlds.  Structur al rules are about w hat 
is true in all possible worlds, so a statement of a fact, not a rule, is more appropriate here:
Fact 6:  The EU-Rent Speedway is in Germany.Rule 7:  Every sports car is alwa ys testable at the EU-Rent Speedway.
Finally, Rule 7 proposes a necessary charact eristic of the concept ‘sports car’.  This  characteristic is an implied characteris tic 
because it is not an incorporated character istic of ‘sports car’.  It follows logical ly from the combinat ion of characteristics  of 
‘sports car’ and ‘E U-Rent Speedway’.
Semantics of Business Vocabula ry and Business Rules, v1.3        11718 Behavioral Guidance
18.1 Behavioral Elements of Guidance
18.1.1 Introduction
Figure 18.1 - Kinds of Beh avioral Elements of Guidance
18.1.2 Behavioral Rules
operative business rule
Definition: business rule  that is a claim of obligation
Definition: element of governance  that is directly enforceable
Dictionary Basis: a prescribed, suggested, or self-imposed  guide for conduct or action : a regulation or principle 
<his parents laid down the rule that he must do his homework before going out to play> <a very sound rule for any hiker is to mind his own business […] F.D.Smith & Barbara Wilcox> 
<made it a rule never to lose his temper> […] 
[MWU (1a) ‘rule’]

118                 Semantics of Business Vocabulary and Business Rules, v1.3)Dictionary Basis: a prescribed guide fo r conduct or action [MWCD ‘rule’]
Necessity: No operative business rule  is a structural business rule .
Synonym: behavioral business rule
behavioral business rule
See: operative business rule
18.1.3 Business Rule Enforcement
enforcement level
Definition: position in a graded or ordered scale of valu es that specifies the severity of action imposed in 
order to put or keep an operative business rule  in force 
Dictionary Basis: a position on a real or imaginary scale of amoun t, quantity, extent, or quality [NODE ‘level’]
Dictionary Basis: compel obse rvance of or compliance with [NODE ‘enforcement’]
Synonym: level of enforcement
Example: An example set of leve ls of enforcement, based on [BMM]  
    
operative business rule  has  enforcement level
18.1.4 Behavioral Advices
advice of permission
Definition: advice  that  is a claim of permissionEnforcement Level:  strict
Definition: strictly enforced (If you violate the rule, you cannot escape the penalty.)
Enforcement Level:  deferred
Definition: deferred enforcement (Stric tly enforced, but enforcement may be 
delayed — e.g., waiting for resource with required skills.)
Enforcement Level:  pre-authorized
Definition: pre-authorized override (Enfor ced, but exceptions al lowed, with prior 
approval for actors with before-the -fact override authorization.)
Enforcement Level:  post-justified
Definition: post-justified override (If no t approved after the fact, you may be 
subject to sanction or other consequences.)
Enforcement Level:  override
Definition: override with explanation (Comment must be provided when the 
violation occurs.)
Enforcement Level:  guideline
Definition: guideline (suggested, but not enforced.)
Semantics of Business Vocabula ry and Business Rules, v1.3        119Note: Every obligation implies a permission. So if an obligation is introduced by a behavioral rule, 
there is no practical reason to introduce the implied permission.  In such cases, best practice 
generally favors keeping the number of elements of guidance to be managed to a minimum. 
Example: (In a bank) There is no rule that a person must be over some given age in order to open a 
savings account: “There is no  minimum age for opening a savings account.” This is 
understood as an advice of perm ission because ‘minimum age’ is defined as “age that must be 
reached in order to take part in a given activity” and no restri ction has been placed on it. In 
other words, the behavi or ‘opening a bank account’ is not to  be disallowed based on age. 
Example: There is no rule that orders placed by FAX will not be accepted: “Placing an order by FAX is 
acceptable.” In other words, placing an  order by FAX is not prohibited. 
advice of optionality
Definition: advice of permission  that  is a claim of optionality
Note: The purpose of an advice of optionality is to preempt application of behavioral "rules" that 
might be assumed to exist, but are not actually included in the body of shared guidance of the 
authority. Often, the reason for this assumption in  a business is that other, similar businesses 
have such rules. Typically, the reason for providing such explicit advice is that people in the 
business have mistakenly applied th e non-existent rule in the past. 
Note: In deontic logic, a proposition that is permi ssible but not obligatory is termed ‘optional’. If 
people in a business were to treat it as an obligation, they would demand compliance that is not required by the business, e.g., to be shown picture id, or that the car be driven to the specified 
return branch (as the foll owing examples illustrate). 
Example: (In EU-Rent)  Advising that it is not obliga tory that a renter show pi cture identification at the 
time of a rental pick-up. This might be expresse d in various ways, for example as: “It is neither 
obligatory nor prohibited that at rental pick-up time the renter shows pict ure identification,” or 
“It is not obligatory (but permitted) that a renter shows picture id in order to pick up his car.”  
Example: (In EU-Rent) Advising that it is not obligatory (or prohibited) that a rented car be dropped off 
only at the return branch specified in the re ntal agreement. This mi ght be expressed, for 
example, as “At the end of a rental, it is not obligatory (but permitted) that a rental car be 
dropped off at the rental agreemen t-specified EU-Rent return branch.”
120                 Semantics of Business Vocabulary and Business Rules, v1.3)18.2 Behavioral Element of Guidance Statements
18.2.1 Statements of  Behavioral Rules
Figure 18.2 - Behavioral Rule Statement and Kinds of Behavioral Rule Statement
operative business rule statement
Definition: rule statement  that  expresses  an operative business rule  
Necessity: No operative business rule statement  is a structural rule statement .
Note: One operative business rule can be expresse d as various equivalent kinds of statements by 
introducing or removing negation. The following are examples of the same rule, expressed in 
three forms.
Example: [as an obligation statement ]  “It is obligatory that  a rental that is open has no driver that is a 
barred driver.”
Example: [as a prohibition statement ]  “It is prohibited that  a rental be open if a driver of the rental is 
a barred driver.”
Example: [as a restricted permission statement ]  “It is permitted that  a rental be open only if no  
driver of the rental is a barred driver.”
obligation statement
Definition: operative business rule statement  that  is expressed positively in terms of obligation  rather 
than negatively in terms of prohibition  
Necessity: No obligation statement  is a prohibition statement .
Necessity: No obligation statement  is a restricted permission statement .
Example: “It is obligatory that a re ntal incurs a location penalty charge if the drop-off location of the 
rental is not the EU-Rent site of the return branch of the rental.”
Example: “A rental must incur a loca tion penalty charge if the drop-off location of the rental is not the 
EU-Rent site of the return branch of the rental.”

Semantics of Business Vocabula ry and Business Rules, v1.3        121prohibition statement
Definition: operative business rule statement  that  is expressed negatively in terms of prohibition   
rather than positively in terms of obligation
Necessity: No prohibition statement  is a restricted permission statement .
Example: “It is prohibited that  the duration of a rental be more than 90 rental days.”
Example: “The duration of a rental must not be more than 90 rental days.”
restricted permission statement
Definition: operative business rule statement  that  is expressed as permission  being granted only 
when a given condition is met 
Example: “It is permitted that a rental  is open only if an estimated rent al charge is provisionally charged 
to the credit card of th e renter of the rental.”
Example: “A rental may be open only if an estimated rental charge is provisionally charged to the credit 
card of the renter of the rental.”
Note: A restricted permission st atement should not be confused with a statement of advice of 
permission. The latter should never contain ‘onl y’, which is always interpreted as eliminating 
or diminishing a degree of freedom (i.e., indicati ng the presence of a rule).  This inclusion of 
‘only’ is the key characteristic of restricted permi ssion statements.
Note: Every restricted permission statement can be rephrased as a conditional prohibition statement.  
The pattern “it is permitted that p only if q” can be stated equivalently as “it is prohibited that p 
if not q” or “it is not permitted that p if not q” (refer to Clause 24).  For example, the following 
three statements mean the same thing:
1. “It is permitted that a rental is open only if an estimated rental charge is provisionally 
charged to the credit card of  the renter of the rental.”
2. “It is prohibited that a rent al is open if an estimated rental charge is not provisionally 
charged to the credit card of  the renter of the rental.”
3. “It is not permitted that a rental is open if an estimated rental charge is not provisionally   
charged to the credit card of  the renter of the rental.”
122                 Semantics of Business Vocabulary and Business Rules, v1.3)18.2.2 Statements of Behavioral Advices
Figure 18.3 - Statement of Advice of Permission and its Kinds
statement of advice of permission
Definition: advice statement  that  expresses  an advice of permission  
Note: One advice of permission can be expressed as  various equivalent kinds of statements by 
introducing or removing negation. The following are examples of the same advice, expressed in alternative forms.
Example: [as a permission statement
]  “It is permitted that the drop-o ff branch of a rental is not the 
return branch of the rental.”
Example: [as a non-obligation statement ] “It is not obligatory that the drop-off branch of a rental be 
the return branch of the rental.”
Example: [as a non-obligation statement ] “The drop-off branch of a re ntal need not be the return 
branch of the rental.”
permission statement
Definition: statement of adv ice of permission  that  is expressed positively in terms of permission   
rather than negatively in terms of non-obligation  
Necessity: No permission statement  is a non-obligation statement .
Example: “It is permitted that the dr op-off branch of a rental is not the return branch of the rental.”

Semantics of Business Vocabula ry and Business Rules, v1.3        123non-obligation statement
Definition: statement of advice of permission  that  is expressed negatively in terms of non-obligation   
rather than positively in terms of permission  
Example: “It is not obligatory that the drop-off branch of a rental be the return  branch of the rental.”
Example: “The drop-off branch of a rental need not be the return branch of the rental.”
optionality statement
Definition: statement of advice of permission  that  expresses  an advice of optionality  
Note: An optionality statement  may take various forms, each expr essing the meaning of the same 
advice of optionality , as illustrated by the following examples. 
Example: “It is neither prohibited nor obligatory that the renter shows photo identification at the pick-up 
time of a rental.”
Example: “It is permitted but not obligatory that the renter shows picture identification at the pick-up 
time of the rental.”
124                 Semantics of Business Vocabulary and Business Rules, v1.3)
Semantics of Business Vocabula ry and Business Rules, v1.3        12519 Business Collections of Meanings and  
Representations
19.1 Bodies of Meanings
19.1.1 Bodies of Shared Meaning
Figure 19.1 - A Body of Shared Meanings and its Composition
body of shared meanings
Definition: set of concepts  and elements of guidance  for which there is a shared understanding in a 
given  semantic community  
Example: The EU-Rent Car Rental Business  has a body of shared meanings  which contains the set of 
concepts of general and specific things of importance to the EU-Ren t car rental business.
Note: When modeling a business (such as EU-Rent), th e universe of discourse, defined in the body 
of shared meanings, is bounded by what the business owners decide is in scope. That would be the actual world of some part of EU-Rent’s busine ss (e.g., rentals, as opposed to, say, premises 
management, purchase/sales of car s, or HR) and some possible wo rlds that are reachable from 
the actual world. If the EU-Rent owners say that  they are considering renting RVs or starting 
up in China, then meanings about possible wo rlds that include these kinds of business are 
included in the body of shared meanings. 

126  Semantics of Business Vocabulary and Business Rules, v1.3If EU-Rent is not considering renting construction equipment or camping  gear, then meanings 
about possible worlds that include these kinds of business are not included in the body of 
shared meanings – and neither are possible worlds that include impossibilities. Whether 
‘Kinnell Construction rented backhoe 123 on 2012-08-28’ or ‘John rode into work on a 
unicorn’ correspond to states of affairs or not, are not relevant to EU-Rent. They are out of 
scope. 
In-scope propositions may have to be constrai ned by necessities to ensure that they are not 
impossible. e.g., ‘Necessity: Each rental car is stored at at most one branch [at any given 
time].’ 
Note: A body of shared meanin gs contains meanings of:
•no
un concepts that define kinds of thing in the business, within the scope being modeled
•verb concept
s that define relationships between kinds of thing in the business, within th e
scop
e being modeled
• elements of 
guidance that c onstrain or govern the things and relationships defined by  the
concepts.
It does not
 contain ground facts or facts derived from ground facts (other than as illustrative 
examples), or things in the business, or information system artifacts that model things in the 
business – although it may provide vocabulary to refer to them. 
body of shared meanings  unites  semantic community  
Definition: the body of shared meanings  is the set of concepts  and elements of guidance  for which 
there is a shared understanding in the semantic community
Necessity: Each semantic community  is united by  exactly one body of shared meanings .
Necessity: Each body of shared meanings  unites  exactly one semantic community .
Note: Understanding the body of shared meanings that unites a semantic community is an obligation 
for participation in the semantic community. Communication within the community is based on an assumption of mutual understanding of the body of shared meaning.
body of shared meanings1 contains  body of shared meanings2
Concept Type: partitive verb concept
Definition: the body of shared meanings  includes everything in the other  body of shared meanings
19.1.2 Bodies of Shared Concepts
body of shared concepts
Definition: all of the  concepts  within a body of shar ed meanings , structured according to the relations 
among them
Synonym: concept model
Note: Clause 14 and sub clause 11.2 provide detail  for what is meant by “the relations among 
[concepts]” in this Definition.
body of shared concepts  includes concept
Concept Type: partitive verb concept
Synonymous Form: concept  is included in  body of shared concepts
Semantics of Business Vocabula ry and Business Rules, v1.3        127body of shared meanings  includes  body of shared concepts
19.1.3 Bodies of Shared Guidance
body of shared guidance
Definition: all of the elements of guidance  within a body of shared meanings
body of shared meanings  includes  body of shared guidance
Definition: the body of shared guidance  is the set of elements of guidance  that are included in  the 
body of shared meanings
Synonymous Form: body of shared guidance  is included in  body of shared meanings
body of shared guidance  includes  element of guidance
Synonymous Form: element of guidance  is included in  body of shared guidance
19.2 Sets of Business Representations
19.2.1 Business Vocabularies
Figure 19.2 - Business Vocabulary

128                 Semantics of Business Vocabulary and Business Rules, v1.3vocabulary
Definition: set of designations  and verb concept wordings  primarily drawn from a single language  
to express concepts  within a body of shared meanings  
Dictionary Basis: sum or stock of words employed by a language, group, individual, or work, or in a field of 
knowledge [MWCD ‘vocabulary’]
Example: The sets of designations represented in EU-Rent’s internal glossaries, in the natural languages 
in which the company does business, together wi th the vocabularies it has adopted, including 
those defined in:  
* Industry standard glossaries for car rental business,  
* Standard (e.g., ISO) glossaries of business terms,  
* Authoritative dictionaries for the relevant natural languages.
Note: A vocabulary contains only designations and verb concept wordings. Contrast a terminological 
dictionary, which further adds definitions, desc riptions, etc. A rulebook includes everything 
that is in a terminological dictionary, plus re presentations of behavior al elements of guidance 
in a body of shared guidance.
Note: Enumerating the designations in a vocabulary is not a matter of listing signifiers, but of 
associating signifiers with concepts, and a concept can be identi fied by a definition.
business vocabulary
Definition: vocabulary  that is under business jurisdiction
vocabulary  is expressed in language
Definition: the designations  of the vocabulary  are primarily within the language  
Synonymous Form: language  expresses  vocabulary
Synonymous Form: vocabulary  uses  language   
Necessity: Each  vocabulary  is expressed in  at least one  language .
Note: Typically, the language would be a natural language, but not necessarily.  See ‘ language ’.
speech community  owns  vocabulary
Definition: the speech community  determines the contents of the vocabulary  
Note: The speech community that ow ns a vocabulary has the authority to change the content of the 
vocabulary.
speech community  uses  vocabulary
Note: A speech community may use a vocabulary that is owned by  a different sp eech community. 
vocabulary  is designed for speech community
Synonymous Form: vocabulary  targets  speech community
Definition: the vocabulary  is created for use by a speech community  that does  not own the 
vocabul ary
Example: A speech community of specialists (such as accountants of engineers) creates a “layman’s 
vocabulary” for their specialization, to be used in discourse with general management.
Example: The legal department of a company creates a vocabulary to be used for legal documents, such 
as contracts.
vocabulary1 incorporates vocabulary2
Concept Type: partitive verb concept
Semantics of Business Vocabula ry and Business Rules, v1.3        129Definition: the vocabulary1 includes  each designation  and verb concept wording  that is included 
in the vocabulary2
Note: When more than one vocabulary is included, a hierarchy of inclusion can provide priority for 
selection of definitions.
Synonymous Form: vocabulary2 is incorporated into vocabulary1
vocabulary  is used to express  body of shared meanings
Definition: the vocabulary  includes designations  and verb c oncept wordings  of the concepts  in the 
body of shared meanings
19.2.2 Speech Community Representation Sets
Figure 19.3 - Speech Community Representation Set
speech community representation set
Definition: set of representations  determined by  a given  speech community  to represent in its 
language  all meanings  in its body of shared meanings
Synonym: representation set
Reference Scheme: the speech community  that determines  the speech community representation set
Note: Besides being an element of a speech community representatio n set, an individual 
representation can appear multiple times
1.  as a component of other representations in that set - e.g., a term can be used in  
     multiple definitions and statements, and
2.  in terminological dict ionaries and/or rulebooks - once for each time the meaning of  
     the representation appears in the terminological dictionary or rulebook.
speech community representation set  includes  representation
Definition: the representation  is an element  in the speech community repre sentation set
Synonymous Form: representation  is included in  speech community representation set
representation  uses  vocabulary
Definition: the representation  is expressed in terms of the vocabulary

130                 Semantics of Business Vocabulary and Business Rules, v1.3speech community  determines  speech community representation set
Definition: the speech community  is responsible for the expression of  representations that are included 
in the speech community re presentation set
Necessity: Each  speech community representation set  is determined by  exactly one   
speech community .
Note: The speech community is res ponsible for translating the inform al representations of the speech 
community representation set into the language of the speech community.
19.3 Ways of Packaging SBVR  Content for Publication
19.3.1 Terminologic al Dictionaries
Figure 19.4 - Terminological Dictionary
terminological dictionary
Definition: collection of representations  including at least one  designation  or definition  of each  of a 
set of concepts  from one or more  specific subject fields , together with other specifications 
of facts  related to those concepts
Source: based on  ISO 1087-1 English  (3.7.1) [‘terminological dictionary’ ]
Reference Scheme: a URI of the terminological dictionary
Note: Terminological dictionaries include designations and verb concept wordings representing 
concepts, and definitions, descriptions, descriptiv e examples, notes, struct ural rule statements 
and other representations of in formation about the concepts. 
Note: Contrast a terminological dictionary with a rulebook, which may include representations of 
behavioral elements of guidan ce in a body of shared guidance.
terminological dictionary  includes  representation
Definition: the representation  is an element of the terminological dictionary

Semantics of Business Vocabula ry and Business Rules, v1.3        131Synonymous Form: representation  is included in  terminological dictionary
terminological dictionary  has URI
Definition: the URI uniquely identifies the terminological dictionary
Necessity: Each  URI is the URI of at most one  terminological dictionary . 
terminological dictionary  presents  vocabulary
Definition: the terminological dictionary  sets forth representations related to the desig nations  and  
verb concept wordings  of the vocabulary
Necessity: Each  terminological dictionary  presents  at least one  vocabulary .
Note: Which terminological entries are to be includ ed in a terminological dictionary is specified by 
one or more vocabularies by  using the verb concept terminological dictionary  presents 
vocabulary . Vocabularies may be assembled from other vocabularies using the verb concept 
vocabulary1incorporates vocabulary2. Terminological dictionaries  can effectively include 
other terminological dictionaries by includ ing the vocabulary(ies)  that specifies the 
terminological en tries in the included  terminological dictionary in the vocabulary that 
specifies the terminological entries in the including  terminological dictionary. 
terminological dictionary  expresses  body of shared meanings
Definition: the terminological dictionary  includes  representations  of the concept s in the body of  
shared meanings
19.3.2 Rulebooks
Figure 19.5 - Rulebook
rulebook
Definition: terminological dictionary  plus a collection of representations  including at least one 
guidance statement  for each of a set of one or more elements of guidance , together with 
any number of other representations  of facts  related to those elements of guidance
Reference Scheme: a URI of the rulebook
Note: Each rulebook includes a terminological dictionary plus, optionally, names of behavioral 
elements of guidance, and guidance statements, synonymous statements, terms for guidance 

132                 Semantics of Business Vocabulary and Business Rules, v1.3types, descriptions, references, notes, descri ptive examples, and other statements (e.g., 
regarding enforcement levels) about th e behavioral elements of guidance.
rulebook  has  URI
Definition: the URI uniquely identifies the rulebook
Necessity: Each  URI is the URI of at most one  rulebook .
Note: A rulebook contains representations (designati ons, verb concept wordings, definitions, notes, 
descriptive examples, etc.) of all meanings of  a body of shared mean ings. This can include 
representations of elemen ts of guidance when a body of shared guidance is included in a body 
of shared meanings.
Contrast a rulebook with a vocabulary, which contains only designations and verb concept 
wordings. Also contrast a terminological dictionary, which contains everything that is in a rulebook except representations of behavioral elements of guidance.
19.4 Business Contents of a Communication
Figure 19.6 - Communication Content
communication content
Definition: representatio n that is a subdivision of a written composition that consists of one or more  
statements and deals with  one point or gives the words of one speaker 
Source: MWCD (1a)
Synonym: message content
Synonym: document content
message content
See: communication content
document content
See: communication content

Semantics of Business Vocabula ry and Business Rules, v1.3        133communication content  is composed of  representation
Concept Type: partitive verb concept
information source
Concept Type: role
Definition: communication content  that is used as a resource to su pply information or evidence 
reference  points to  information source
Definition: the communication content  plays the role of an information source  for the reference   
19.5 Namespaces
19.5.1 Namespace
Figure 19.7 - Namespace and Kinds of Namespace
namespace
Definition: collection of designations  and/or verb concept wordings  that are distinguishable from each 
other by uniqueness of designator or form
Reference Scheme: a URI of the namespace
namespace1 incorporates  namespace2
Definition: each  designation  and verb concept wording  in the namespace2 is in the namespace1, 
and if the  namespace1 is a vocabulary namespace , each  attributive namespace  within  

134                 Semantics of Business Vocabulary and Business Rules, v1.3the vocabulary namespace2 is incorporated into an attributive namespace  in the 
namespace1 for the same subject concept
designation  is in namespace
Definition: the namespace  contains the designation  such that the signifier  of the designation  is the 
signifier  of no other desig nation  in the namespace
Synonymous Form: namespace  contains  designation
verb concept wording  is in namespace
Definition: the namespace  contains  the verb concept wording  such that it is distinguishable from 
every other verb concept wo rding  in the namespace  
Synonymous Form: namespace  contains  verb concep t wording
Note: The distinguishability of a verb concept wording from others  within a namespace is based on 
how a use of the verb concept wording is recogni zed.  Distinguishability considers positions of 
placeholders, meanings of designations used by placeholders and the e xpression of the verb 
concept wording excluding ex pressions of placeholders. 
Example: The verb concept wording ‘proposition  is true’ (with placeholder ‘proposition ’) is 
indistinguishable from ‘[proposi tion] is true’ (with placeholde r ‘[proposition]’) because both 
placeholders use a designation of the same con cept (‘proposition’), but those two forms are 
distinguishable from ‘line  is true’ (with placeholder ‘line ’) because ‘proposit ion’ and ‘line’ 
designate different concepts.
namespace  has  URI
Definition: the URI uniquely identifies the namespace  
Necessity: Each URI is the URI of at most one namespace .
19.5.2 Vocabulary Namespaces
vocabulary namespace
Definition: namespace  that is derived from  a vocabulary
vocabulary namespace  is derived from  vocabulary
Definition: the designations  and verb concept wordings  in the voca bulary namespace  are from the 
vocabulary
Note: This specification does not require any particular  process of derivation. But a typical process is 
that all designations and verb concept wordings  that are directly distinguishable by their 
expressions are put into one vocab ulary namespace. In the case of one or more designations or 
verb concept wordings being undistinguishable except by their subject fields, an additional vocabulary namespace is derived specif ically for those subject fields. 
vocabulary namespace  is for language
Definition: each  representation  in the vocabulary names pace  is for expression in the language  
vocabulary namespace  is specific to designation context
Definition: each  designation  and verb concept wording  that is in the vocabulary namespace  is in 
the designation context
Semantics of Business Vocabula ry and Business Rules, v1.3        135vocabulary namespace  is specific to subject field
Definition: each  designation  and verb concept wording  that is in the vocabulary namespace  is in 
the subject field
19.5.3 Attributive Namespaces
attributive namespace
Definition: namespace  that contains  designations  recognizable in the contex t of being attributed to 
instances  of a particular concept
Necessity: Each attributive namespace  is for exactly one subject concept .
Reference Scheme: a vocabulary namespace  that includes  the attributive namespace  and the subject  
concept  that has the attributive namespace
Note: A designation  in an attributive namespace  typically represents a role of a binary verb  
concept .  In English, such a designation can typica lly be used with any of several attributive 
forms, such as “... has …” or “… of …”.  A designation  in an attributive namespace  can 
also represent a characteristic .  Different languages have different attributive forms - 
different grammatical structur es relating a subject to something attributed to it. 
Example: Given an attributive namespace  for the subject concept  ‘rental’, a designation  ‘drop-off 
date’ can be used in any of several attributive fo rms:  “rental has drop-off date,” “drop-off date 
of rental,” “rental’s drop-off date,”  “drop-off date is of rental,” etc.
Example: Given an attributive namespace  for the subject concept  ‘rental’, the designation  
‘assigned’ for the characteristic  ‘rental  is assigned’ is recognized where it applies to a rental, 
as in “assigned rental.” 
attributive namespace  is for subject concept
Definition: the designations  in the attributive namespace  are for concepts  attributable to instances  
of the subject concept
Synonymous Form: concept  has attributive namespace
attributive namespace  is within vocabulary namespace
Definition: the attributive namespace  is a section of the vocabulary namespace  attributable to the 
concept  that has the attributive namespace
Synonymous Form: vocabulary namespace  includes  attributive namespace
136                 Semantics of Business Vocabulary and Business Rules, v1.3
Semantics of Business Vocabula ry and Business Rules, v1.3)        13720 Adoption
20.1 Adoption of Definitions
Figure 20.1 - Definition Adoption
Definition Origin
Definition: the categorization scheme  of the concept  ‘definition ’ that  classifies  a definition  based on 
whether it  is owned by its speech community  or adopted by its speech community
owned definition
Definition: definition  that a  speech community  ‘owns’ and is responsible for creating and maintaining
Necessity: The concept  ‘owned definition ’ is included in Definition Origin .
Example: EU-Rent ‘owns’ its definition of the concept of ‘barred driver’.
speech community  owns owned definition
adopted definition
Definition: definiti on that  a speech community  adopts from an external source by providing a 
reference  to the definition  
Necessity: The concept  ‘adopted definition ’ is included in Definition Origin .
Necessity: Each  adopted definition  must  be of a concept  in the body of shared meanings  that 
unites  the semantic community  that has the speec h community .

138                 Semantics of Business Vocabulary and Business Rules, v1.3Example: SBVR has adopted the concept ‘concept’ (‘ unit of knowledge created by a unique combination 
of characteristics’) from ISO 1087-1 (English) (3.2.1).
Note: By adopting the definition of ‘concept’, the SBVR community adopted the meaning of 
‘concept’ as represented by the definition. A m eaning cannot be adopted in the abstract; it is 
adopted via a representation of  the meaning - a definition.  
 A definition is expressed in some language, so  is adopted by some speech community within 
the adopting semantic community.  
 Adoption of the definition first adopted by a semantic community (via one of its speech 
communities) is the adoption of the concept.
Example: Adoption of the definition of ‘concept’ from ISO 1087 by the English-speaking SBVR speech 
community.
Note: Subsequent definitions of the adopted concept (e.g., in other natural languages) must have the 
same meaning as the first adopted definition. 
Example: Adoption of the definition of ‘concept’ (‘unité de connaissance créée par une combinaison 
unique de caractères’) from ISO 1087 by the French-speaking SBVR speech community.
Note: The primary term used for the concept does not have to be the same as the primary term in the 
source.
Example: SBVR has adopted the definition of ‘object’ from ISO 1087, but uses the term ‘thing’ to 
designate it. 
Example: The French-speaking SBVR speech commun ity might choose to use the synonym ‘notion’ 
(also used in ISO 1087) instead of ‘concept’. 
Note: When an adopted concept is designated by a pr eferred term or verb symbol different from the 
one in the source, related adopted definitio ns may be localized with these preferred 
designations while retaining their meanings. 
Example: SBVR has adopted the definition of ‘individual noun concept’ (‘concept that corresponds to 
only one object’) from ISO 1087 but, using its preferred term ‘thing’ instead of ‘object’, has 
localized it as ‘concept that co rresponds to only one thing’.
Note: When a concept’s definition is adopted, all other concepts in the referenced source that are 
used in the definition are also adopted. These adoptions may be  explicit in the adopting speech 
community’s vocabulary or implicit within the source vocabulary. 
speech community  adopts  adopted definition  citing  reference
Definition: the speech com munity  agrees that the definition  identified by the refere nce can serve as 
the adopted definition  
Note: The reference is the name of the source a nd the designation used in the source with, if 
available, informally-styled referencing within the source - ‘(3.2.1)’ in the example below.
Example: ISO 1087-1 (English)  (3.2.1) [‘concept ’]
20.2 Adoption of Business Rules
Elements of guidance may be adopted from  external authorities. Th ese external authorities mi ght be membership-based 
associations for certain industries (e.g.,  finance, healthcare, teleco mmunications), for certain pr ofessional practices (e.g., 
accountancy, law, human resources), or for certain domain exper tise (e.g., biofuels, photograph y, software engineering). If 
elements of guidance are adopted, the concepts – noun concepts a nd verb concepts – used in defining the elements of guidance 
Semantics of Business Vocabula ry and Business Rules, v1.3)        139must be included in the body of shared concepts of the adopting authority. This usually means that the concepts have been 
adopted from, or defined in collaboration with, the providing aut hority that is the source of th e adopted elements of guidance.  
Figure 20.2 - Element of Guidance Adoption
authority  authors  guidance statement
Definition: the authority  authors  a guidance statement  that expresses  some  element of guidance  
Note: An authority may author guid ance statements for adopted elemen ts of guidance as well as for 
elements of guidance it defines.
authority  defines  element of guidance
Definition: the authority  authors  the first guidance statement  that expresses  the element of  
guidance  
Necessity: Each  element of guidance  is defined by  exactly one  authority .
adopting authority  
Concept Type: role
Definition: authority  that adopts  some  element of guidance

140                 Semantics of Business Vocabulary and Business Rules, v1.3owning authority  
Concept Type: role
Definition: authority  that has business jurisdiction over some  element of guidance
adopting authority  adopts  element of guidance  from owning authority  citing reference
Definition: the authority  adopts  the element of guidance  from the owning authority  citing  a 
reference  that points to  a guidance statement  that expresses  the element of guidance  
Necessity: The reference  that is cited by  an owning authority  that adopts  an element of guidance  
from an owning authority  points to  a guidance statement  that expresses  the element  
of guidance  and that  is included in  a rulebook  that is determined by  a speech  
community  of the  owning authority .
Note: An element of guidance cannot be adopted in the abstract; it is adopted via a representation of 
the meaning - a guidance statement
Note: Subsequent guidance statements of the adopted  element of guidance (e.g., in other natural 
languages) must have the same meaning as the first adopted guidance statement.
Note: When a guidance statement is adopted, all concepts in the refe renced source that are used in 
the guidance statement are also adopted. These adoptions may be explicit in the adopting authority’s vocabulary, or implicit, within the source vocabulary. 
Note: The primary guidance statement used for the element of guidance does not have to be the same 
as the primary guidance statemen t in the source. Concepts used  in the element of guidance 
should be represented by their preferred terms and verb symbols in the adopting body of shared guidance. 
Example: EU-Rent has adopted an behavioral busines s rule from from an industry glossary: “Before 
handover of a rented car, the rental contract mu st be signed by the customer responsible for the 
rental”. EU-Rent uses its own pr eferred terms, ‘rental contract document’ and ‘renter’ for its 
primary guidance statement: “The rental contract document of a rental must be signed by the 
renter of the rental before handover of the rented car of the rental”.
Semantics of Business Vocabula ry and Business Rules, v1.3        14121 Logical Formulation of Semantics
21.1 General
The vocabulary in this clause is not intended for use by business  people in general, but rather, it is a vocabulary used to 
describe the formal semantic structures of business discourse.  It is not for disc ussing business, but for discussing the 
semantic structures underlying business communications of c oncepts, propositions and questio ns.  For example, a typical 
business person does not tend to talk about quantifications, but he expresses quantific ations in almost every statement he 
makes.  He doesn’t tend to talk about conjunctions, disj unctions, logical negations, ante cedents and consequents, but 
these are all part of the formulation of his thinking. The vocab ulary in this clause is for talking about these conceptual 
devices that people use all the time.
Semantic formulations are not representa tions or expressions of meaning. Rather, they are structures of meaning – the 
logical composition of meaning.
Business rules are generally expressed in natural language, although some rules are at times illustrated graphically. SBVR 
does not provide a logic language for restating business rules in some other language that business people don’t use. 
Rather, SBVR provides a means for describing the structure of the meaning of rules expressed in the natural language that 
business people use.  Semantic formulations are not expressi ons or statements.  They are structures that make up 
meaning. Using SBVR, the meaning of a definition or statemen t is communicated as facts about the semantic formulation 
of the meaning, not as a restatement of the meaning in a formal language.
There are two kinds of semantic formulatio ns. The first kind, logical formulation, structures propositions, both simple and 
complex.  Specializations of that kind are given for various logical operations, qu antifications, atomic formulations based 
on verb concepts and other formulations for special purposes such as objectifica tions and nominalizations.
The second kind of semantic formulation is projection. It structur es intensions as sets of thi ngs that satisfy constraints. 
Projections formulate definitions , aggregations, and questions. 
Semantic formulations are recursive.  Se veral kinds of semantic formulations em bed other semantic formulations.  Logic 
variables are introduced by quantifications (a kind of logical formulation) and projections so that embedded formulations 
can refer to instances of concepts.  A l ogic variable used in a formulation is fre e within that formulation if it is not 
introduced within that formulation.  A formulation is closed  if no variable is free within it. Only a closed semantic 
formulation can formulate a meaning.  If a formulation has a variable that is free with in it, then it can be part of a larger 
formulation of a meaning (one that introduces the variable) but it does not by itself formulate a meaning.
The hierarchical composition of semantic formulations is seen  in the following example of a very simple business rule.  
The rule is stated in different ways but is one rule having one meaning.  Many other statements are possible.
•      A rental must have at most three additional drivers.
•      It is obligatory that each rent al has at most thr ee additional drivers.
Below is a representation of a semantic formulation of the rule above as sentences that convey the full structure of the 
rule.   Note that different semantic formulations are possibl e for the same meaning.  Two semantic formulations can be 
determined to have the same meaning either by logical analys is or by assertion (as a matter of definition).  A single 
formulation is shown below.  
The rule is a proposition meant by an obligation formulation.
. That obligation formulation embe ds a universal quantification.
 . . The universal quantificatio n introduces a first variable.
 . . . The first variable ranges over the concept ‘rental’.
142                 Semantics of Business Vocabulary and Business Rules, v1.3 . . The universal quantification scop es over an at-most-n quantification.
 . . . The at-most-n quantification has the maximum cardinality 3. . . . The at-most-n quantification introduces a second variable.
 . . . . The second variable ranges over the concept ‘additional driver’.
 . . . The at-most-n quantification sc opes over an atomic formulation.
 . . . . The atomic formulation is based on the verb concept ‘rental
 has additional driver ’.
 . . . . . The atomic formulation has a role binding.
 . . . . . . The role binding is of the role ‘rental ’ of the verb concept.
 . . . . . . The role binding binds to the first variable. . . . . . The atomic formulat ion has a second role binding.
 . . . . . . The second role binding is of the role ‘additional driver
’ of the verb concept.
 . . . . . . The second role binding binds to the second variable. 
Note that designations like ‘rental’ and ‘additional driver’ repr esent  concepts.  The semantic formulations involve the 
concepts themselves, so identifying the concept ‘rental’ by a nother designation (such as from  another language) does not 
change the formulation.
The indentation in the example shows a hierarchical structure in which a semantic formulation at one level operates on, 
applies a modality to, or quantifies over one or more semantic formulations at the next lower level.  Each kind of logical 
formulation, including modal formulations, quantifications, a nd logical operations, can be embedded in other semantic 
formulations to any depth and in almost any combination.
Within the one atomic formulation in the example are bindings to two variables. The variable s are free within the atomic 
formulation because they are introduced outsi de of it (higher in the hierarchical st ructure).  For this reason, the atomic 
formulation has no meaning.  But the obligation formula tion has a meaning (the rule) and so does the universal 
quantification within the obligation formulation because both are closed. 
Semantic formulations are furthe r exemplified for a simple defin ition of a characteristic, “driver  is of age.”  
Definition:  the age of the driver is at least the EU-Rent Minimum Driving Age
Below is a representation of a semantic formulation of the definition.  Note that different semantic formulations are 
possible.  A single formulation is shown below.  
The characteristic is defined by a projection.
 . The projection is on a first variable.
 . . The first variable ranges over the concept ‘driver’.
 . . The first variable maps to the one role of the characteristic.
 . The projection is constrained by  a first universal quantification.
 . . The first universal quantifi cation introduces a second variable.
 . . . The second variable ranges over the concept ‘age’.
 . . . The second variable is unitary. . . . The second variable is rest ricted by an at omic formulation.
 . . . . The atomic formulation is based on the verb concept ‘driver
 has age ’.
 . . . . The atomic formulation has a role binding.
 . . . . . The role binding is of the role ‘driver ’ of the verb concept.
 . . . . . The role binding binds to the first variable. . . . . The atomic formulation has a second role binding.
 . . . . . The second role binding is of the role ‘age
’ of the verb concept.
 . . . . . The second role binding binds to the second variable.
Semantics of Business Vocabula ry and Business Rules, v1.3        143  . . The first universal qu antification scopes over a s econd universal quantification.
  . . . The second universal quantification introduces a third variable.  . . . . The third variable ranges over the concept ‘EU-Rent Minimum Driving Age’.
  . . . . The third variable is unitary.
  . . . The second universal quantification scopes over an atomic formulation.  . . . . The atomic formulation is based on the verb concept ‘quantity
1 > quantity2’.
  . . . . . The atomic formulation has a role binding.
  . . . . . . The role binding is of the role ‘quantity1’ of the verb concept.
   . . . . . . The role binding binds to the second variable.
  . . . . . The atomic formulation has a second role binding.  . . . . . . The second role binding is of the role ‘quantity
2’ of the verb concept.
  . . . . . . The second role binding binds to the third variable. 
The projection that defines the characteris tic is on a single variable.  A projectio n defining a binary verb concept is on 
two variables, one mapped to each role.  Note that the de finition of the characteristic above uses two binary verb 
concepts, but all of the roles of those ve rb concepts are bound to variables introduced by the projection or by formulations 
within in, so the projection is closed and conveys a meaning.
SBVR does not attempt to provide special semantic formulations  for tenses or the variety of ways states and events can 
relate to each other with respect to time or can be related to times, periods, and dur ations.  However, an objectification is 
a logical formulation that enables a state or event indica ted propositionally to be the su bject or object of other 
propositions.  An encompassing formulation can relate a state or event indicated using an objectification to points in time, 
periods, and durations, or to another state or event (possibly al so identified using an objectif ication) with respect to time 
(e.g., occurring after or occurring before). The specific relations of interest can be defined as verb concepts.  SBVR’s 
treatment of time in relation to states and events allows tem poral relations to be defined ge nerically and orthogonally to 
the many verb concepts whose extensions change over time.
A propositional nominalization is similar to an objectification.  It is a kind of logical formulation that structures the 
meaning represented by a mention of a statement or propos ition as opposed to a use of it.  Other similar types of 
formulations structure meanings represented by mention of c oncepts, questions, and answers.  Furthermore, rules about 
change often involve noun concept nominali zations, which are special formulations th at allow a concept to be a subject or 
object of a proposition in much the same way that proposition nominalization allows a prop osition to be a subject or 
object. 
Semantic formulations are structures, and as such, are identified structurally as finite directed graphs.  The reference 
schemes for semantic formulations and th eir parts take into account their entire st ructure.  In some cases, a transitive 
closure of a reference scheme shows partia l loops (partial in the sense that only a part of a reference scheme loops back, 
never all of it).  This approach allows pa rts of a closed formulation to be identifie d by what it is in its particular context 
while, at the same time, contributing to the unique identity of the formulation that contains it.
144                 Semantics of Business Vocabulary and Business Rules, v1.321.2 Semantic Formulations
Figure 21.1
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by two different interpretations.  See Clause 13 and Annex C.
semantic formulation  FL
Definition: conceptual structure of meaning  
Note: The definitions of several specializations of  ‘semantic formulation’ explain what meaning is 
formulated. A meaning is directly  formulated only for a closed semantic formulation. In the 
case of variables being free within a semantic formulation, a meaning is formulated with respect there being exactly one refere nt thing given for each free variable. 
closed semantic formulation  FL
Definition: semantic formulation  that includes  no variable  without binding
closed semantic formulation  formulates meaning
Definition: the meaning  is structured by the closed semantic formulationlogical formulationsemantic formulation
meaningclosed semantic formulation
formulatesprojection
Semantics of Business Vocabula ry and Business Rules, v1.3        14521.3 Logical Formulations
Figure 21.2
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by  two different interpretations.  See Clause 13 and Annex C.
logical formulation  FL
Definition: semantic formulation  that formulates a proposition
Necessity: Each logical formulation  is an instance  of exactly one logical formulation kind .
logical formulation kind  FL
Definition: general concept  that specializes  the concept  ‘logical formulation ’ and that  classifies a 
logical  formulation  based on the presence or absence of a main logical operation or 
quantification
Note: The absence of a main l ogical operator occurs for an atomic formulation  or instantiation  
formulation .
Example: logical negation , conjunction , universal quantification
closed logical formulation  FL
Definition: logical formulation  that is a closed semantic formulation
Necessity: Each meaning  formulated by a closed logical formulation  is a proposition .
Necessity: Each  closed logical formulation  means exactly one proposition .
Necessity: Each closed logical formulation  that formalizes a statement  means  the proposition  that 
is expressed by  the statement .logical form ulation
closed logical form ulationclosed semantic formulation
atomic formulation
instantiation formulation
propositionmeans modal formulation
logical operation
quantification
objectification
projecting form ulation
proposition nom inalizationgeneral concept
logical formulation kindstatementformalizes1 {sub sets formulates }
146                 Semantics of Business Vocabulary and Business Rules, v1.3closed logical formulation  means proposition  FL
Definition: the closed logical formulation  formulates  the proposition
closed logical formulation  formalizes statement  FL
Definition: the closed logical formulation  means  the proposition  that is expressed by  the 
statement  and the  closed logical formulation  refers to the concepts represented in the 
statement
Example: If ‘barred driver’ is defined as “person that must not drive a car ,” then the statements “Ralph is 
a barred Driver” and “Ralph is a person that  must not drive a car” express the same 
proposition.  But those two statem ents are formalized differently : one in reference to ‘barred 
driver’ and the other in reference to ‘person’, ‘car’, and ‘person  drives car ’.  The two 
formulations are different but  mean the same proposition.
21.3.1 Variables and Bindings
Figure 21.3
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by two different interpretations.  See Clause 13 and Annex C.
variable  FL
Definition: reference to an element of a set, whose referent may vary or is unknown
Note: The set of referents of a variable is defined by the two verb concepts ‘ variable  ranges over  
concept ’ and ‘ logical formulation  restricts  variable ’.  The set is limited to instances of the 
concept, if given.  If the variab le is restricted by a logical formulation, the set is further limited 
to those things for which the meaning formulated by that logical formulation is true when the thing is substituted for each occu rrence of the variable in the formulation.  If there is no 
concept and no restric ting logical formulation the set includes every thing
.
Necessity: Each variable  ranges over  at most one concept . 
Necessity: Each  variable  is restricted by  at most one  logical formulation .
Reference Scheme: a quantification  that introduces  the variable  and the set of concepts  that are ranged 
over by  the variable  and the set of logical formulations  that restrict  the variable and 
whether the variable  is unitary

Semantics of Business Vocabula ry and Business Rules, v1.3        147Reference Scheme: a projection  that is on  the variable  and a  projection  position  of the variable  and the set 
of concepts  that are ranged over by  the variable  and the set of logical formulations  that 
restrict  the variable and whether the  variable  is unitary .
variable  ranges over concept  FL
Definition: each referent of the variable  is an instance of the concept
Synonymous Form: variable  has ranged-over concept
logical formulation  restricts variable  
Definition: for each referent of the variable , the meaning formulated by the logical formulation  is true 
when the referent is subst ituted for each occurrence of the variable  in the logical formulation
Synonymous Form: variable  has restricting formulation
Note: The meaning of the logical formulation  is true for every actual referent of the variable.  The 
things for which the meaning of the logical fo rmulation is false are not considered to be 
referents of the variable.
Note: A logical formulation restrict s a variable in the same way th at a concept ranged over by the 
variable restricts the variable. It limits what the variable refers to.  A restrictive clause in a 
statement is generally fo rmulated as a logical formulation that  restricts a variable.  A variable 
restricted by a logical formula tion is, except in rare cases, a free variable of the logical 
formulation.
Example: “Each rental car that is inop erable is unavailable.”  In the fo rmulation below, a variable ranges 
over the concept ‘rental car’ and is restricted by an atomic formulation based on the verb 
concept ‘vehicle  is inoperable’.  Referents of the variable  are thereby restrict ed to being rental 
cars and to being vehicles that are inoperable.
Example: The proposition is meant by a universal quantification.  
. The universal quantifica tion introduces a variable.  
. . The variable ranges ov er the concept ‘rental car’.  
. . The variable is restrict ed by an atomic formulation.  
. . . The atomic formulation is based on the verb concept ‘vehicle  is inoperable’.  
. . . . The ‘vehicle ’ role is bound to the variable.  
. The universal quantification scop es over an atom ic formulation.  
. . The atomic formulation is base d on the verb concept ‘rental car  is unavailable’.  
. . . The ‘rental car ’ role is bound to the variable.  
variable  is unitary                                                                                                                                                                FL
Definition: the variable  is meant to have exactly one referent in the context where the variable  is 
introduced
Note: This characteristic is used particularly in the formulation of definite descriptions.  
 If a set projection is on one variable and that vari able is unitary, then the projection is meant to 
have exactly one result.  For any other projection on a unitary variable, the projection is meant to have one referent for that variable for each comb ination of referents of other variables 
(including auxiliary variables) in the same projection.  
 If a unitary variable is introduced by a unive rsal quantification, the variable ranges over a 
concept and is restricted by a logical formulation, then the quantification is satisfied if:
1. the unitary variable has exactly one referent , an instance of the c oncept, for which the  
restricting logical formulation is satisfied.
148                 Semantics of Business Vocabulary and Business Rules, v1.32. the logical formulation that the universal quantification scopes over is also satisfied for  
that one referent.
An exactly-one quantification introducing a non-unitary variable is satisfied differently: 
1. the variable has at least one referent, an inst ance of the concept, fo r which the restricting  
logical formulation is satisfied.
2. the logical formulation that the exactly-one quantification scopes over is satisfied for  
exactly one referent from 1 above.
Example: Given the individual noun concept ‘London-Heathrow Branch’ defined as “the EU-Rent 
branch located at London-Heathr ow Airport,” the definition can be formulated as a projection 
on a variable that ranges over the concept ‘EU-Re nt branch’.  The variab le is unitary indicating 
the sense of the definite article “the.”  Ba sed on this formulation, the concept ‘London-
Heathrow Branch’ is understood to be an individual noun concept. If the variable is not made unitary, then the formulation captures only the characteristic of being located at London-Heathrow Airport without any indication of the intended meaning that there is exactly one such branch.
Example: A sensible projection formulating “the renter of a given rental” is on a unitary variable (renter) 
and has an auxiliary variable (r ental).  The rental variable be ing unitary indicates there is 
exactly one renter for each rental.  But a set projection formulating “renter of at least one 
rental” is not on a unitary variable because the variable for rental is introduced within the 
logical formulation that constrains the projection and not by the projection itself.  The projection result can include multiple renters and does not relate these to particular rentals.  
Example: A possible formulation of the rule, “The pick-up location of  each rental must be a EU-Rent 
branch,” has a variable for ‘pic k-up location’ that is unitary with respect to each rental as 
indicated by the use of the defin ite article “the.”  The possible  formulation is an obligation 
formulation that embeds a universal quantification introducing a variable ranging over the concept “rental” and that embeds a second universal quantificati on introducing a second 
variable which is restricted by an atomic fo rmulation based on the verb concept ‘rental
 has 
pick-up location’.  That second variable is un itary indicating that exact ly one pick-up location 
is meant for each rental.  The second universal quantification scopes over  a formulation of the 
pick-up location being a EU-Rent branch.  Th e overall formulation applies the obligation 
formulation to the pick-up location being a EU-Rent branch.  It does not apply the obligation formulation to there being one pi ck-up branch per rental, which is understood structurally as 
what is meant in the expression of th e rule and not part of the obligation.  
 Note that if the universal quantifications of the formulation above are reversed such that a 
quantification introducing the variable for ‘pick-up location’ embeds the quantification introducing the variable for ‘rental’, then the variable for ‘pick-up rental’ is not unitary because it would have multiple referents (one  for each distinct pick-up location). Such a 
formulation would not properly capture the sense of the rule statement.
variable  is free within semantic formulation  FL
Definition: the semantic formulation  employs the variable , but does not introduce it
Synonymous Form: semantic formulation  includes  variable  without binding
bindable target  FL
Definition: variable , expression  or individual noun concept
Semantics of Business Vocabula ry and Business Rules, v1.3        149Note: The meaning of binding to a variable from  a logical formulation, such as an atomic 
formulation, is that a referent of the variable is the thing involved in or considered by the formulation.
Note: The meaning of binding to an individual noun concept from a logical formulation is that the 
formulation refers to the one instance of th e individual noun concept. A difference between 
binding to an individual noun concept and binding to a variable that ranges over the individual noun concept is that a variable can be further re stricted by a logical formulation giving it the 
possibility of refering to nothing. 
Note: The meaning of binding to an expression (such as a text or graphic) fr om a logical formulation 
is that the formulation refers to the expression itself without regard to any meaning the expression might have.
Example: “The text ‘EU-Rent’ is inscribed on each EU-Rent vehicle.”  A logi cal formulation of this 
proposition involves a binding to the text “EU-Re nt,” which simply refers to that expression, 
not to the individual noun concept ‘EU-Rent’ nor  to any representation of it.  The logical 
formulation also involves a binding to a variable that ranges over the concept ‘EU-Rent vehicle’.  
 The proposition is meant by a universal quantification.  
. The universal quantifica tion introduces a variable.  
. . The variable ranges over the concept ‘EU-Rent vehicle’.  
. The universal quantification scop es over an atom ic formulation.  
. . The atomic formulation is based on the verb concept  
                           ‘expression
 is inscribed on object ’. 
. . . The ‘expression ’ role is bound to the text “EU-Rent.”  
. . . The ‘object ’ role is bound to the variable
Example: “The logo    is inscribed on each EU -Rent vehicle.” This example is the same as 
the one above except that the ‘expression’ role is bound to the logo .

150                 Semantics of Business Vocabulary and Business Rules, v1.321.3.2 Atomic Formulations
Figure 21.4
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by two different interpretations.  See Clause 13 and Annex C.
atomic formulation  FL
Definition: logical formulation  that is based on a verb concept  and that has a role binding  of each role 
of the verb concept  and that formulates th e meaning: there is an actuality  that involves in 
each role of the verb concept  the thing to which the bindable target  of the corresponding 
role binding  refers
Concept Type: logical formulation kind
Necessity: Each atomic formulation  is based on exactly one  verb concept .
Reference Scheme: the set of role bindings  of the atomic formulation
Note: The meaning invoked by an at omic formulation puts each referent of each role binding in its 
respective verb concept role.  Where a verb con cept role ranges over some general concept, 
that meaning implies (as a separate secondary mean ing) that the referent of the role binding for 
that role is an instance of the general concept.
Example: “EU-Rent purchases from General Motors Company.”  
The statement is formulated by an atomic formulation.  
. The atomic formulation is based on the verb concept ‘company  purchases from vendor ’. 
. The atomic formulation has a first role binding.  
. . The first role binding is of the role ‘company ’ of the verb concept.  
. . The first role binding binds to the individual noun concept ‘EU-Rent’.  
. The atomic formulation has a second role binding.  
. . The second role binding is of the role ‘vendor ’ of the verb concept.  
. . The second role binding binds to the individual noun concept ‘General Motors Company’.
atomic formulation  has role binding  FL
Definition: the atomic formulation  includes the role binding  for a particular role of the verb concept  
that is the basis of the atomic formulation
Synonymous Form: role binding  occurs in atomic formulationbindable targetatomic form ulation
role bindingverb concept
verb concept roleoccurs 
in
binds tounderliesis based on
role 
binding
111
references1
role 
binding
Semantics of Business Vocabula ry and Business Rules, v1.3        151atomic formulation  is based on verb concept                                                                                                        FL
Definition: the meaning invoked by the atomic formulation  is that of the verb concept
Synonymous Form: verb concept  underlies atomic formulation
role binding                                                                                                                                                                            FL
Definition: connection of an atomic formulation  to a bindable target
Necessity: Each role binding  occurs in  exactly one atomic formulation .
Necessity: Each role binding  is of a role of the verb concept  that underlies  the atomic formulation  
that has the role binding .
Necessity: Each role binding  binds to  exactly one bindable target .
Necessity: Each role binding  is of exactly one verb concept role .
Necessity: Each variable  that is referenced by  a role binding  of an atomic formulation  is free 
within the atomic formulation .
Reference Scheme: the bindable target  that is referenced by  the role binding  and the verb concept role  
that has the role binding
role binding  binds to bindable target                                                                                                                         FL
Definition: the bindable target  provides what thing fills the verb concept role that has the role binding  
in the meaning formul ated by the atomic formulation that has the role binding
Synonymous Form: role binding  references bindable target
verb concept role  has role binding                                                                                                                              FL
Definition: the role binding  is a binding of the verb concept role , which is of the verb concept  that 
underlies an atomic formulation
21.3.3 Instantiation Formulations
Figure 21.5
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by  two different interpretations.  See Clause 13 and Annex C.
instantiation formulation                                                                                                                                                    FL
Definition: logical formulation  that  considers a concept  and binds to a bindable target  and that 
formulates the m eaning: the thing to which the bindable target  refers is an instance  of the 
concept
Concept Type: logical formulation kind
Necessity: Each instantiation formulation  considers  exactly one concept .
Necessity: Each instantiation formulation  binds to  exactly one bindable target .bin dabl e t ar getconcept i nstanti ation formulationconsiders
binds to1
1 is bound  t o
152                 Semantics of Business Vocabulary and Business Rules, v1.3Necessity: Each variable  that is bound to  an instantiation formulation  is free within the 
instantiation formulation .
Reference Scheme: the bindable target  that is bound to  the instantiation formulation  and the concept  that 
is considered by  the instantiation formulation
Note: An instantiation formulation  is equivalent to an existential quantification  that introduces a 
variable  ranging over the concept  considered by the instantiation formulation  and that 
scopes over an atomic formulation  based on the verb concept  ‘thing  is thing ’ where one role 
binding  is to the variable  and the other is to the bindable target  bound to the instantiation  
formulation .
Example: “EU-Rent is a car rental company.”  
The statement is formulated by  an instantiation formulation.  
. The instantiation formulation consid ers the concept “car rental company”.  
. The instantiation formulation binds to the individual noun concept ‘EU-Rent’.
instantiation formulation  considers concept  FL
Definition: the instantiation formulation  classifies things to be an instance  of the concept
instantiation formulation  binds to bindable target  FL
Definition: the bindable target  indicates what thing  is being classified by the instantiation formulation
Synonymous Form: bindable target  is bound to instantiation formulation
21.3.4 Modal Formulations
Figure 21.6
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by two different interpretations.  See Clause 13 and Annex C.
modal formulation  FL
Definition: logical formulation  that formulates that th e meaning of another logical formulation  has a 
particular relationship to possibl e worlds or to acceptable worlds
Necessity: Each  modal formulation  embeds exactly one logical formulation .
Necessity: Each variable  that is free within  a logical formulation  that is embedded in a modal  
formulation  is free within the modal formulation .l ogi cal  form ulation
m odal formulation
necessity
for mul ati onob li gat ion
for mul ati onpe rmis sibi li ty
fo rm ulationpo ssibility
fo rm u latio nem bed s1
is em bedded in
Semantics of Business Vocabula ry and Business Rules, v1.3        153Example: “EU-Rent may purchase from General Moto rs Company.” The statem ent is formulated by a 
permissibility formulation (a kind of modal formulation) that embeds the entire formulation shown in the previous sub clause  in the example under ‘atomic formulation’ - the formulation 
of “EU-Rent purchases from General Motors Company.”  The meaning of the permissibility 
formulation is that EU-Rent purchases from General Motors Company in some possible world.
modal formulation  embeds logical formulation                                                                                                     FL
Definition: the modal formulation  formulates that the meaning of the logical formulation  has a 
particular relationship to possibl e worlds or to acceptable worlds
Synonymous Form: logical formulation  is embedded in modal formulation
necessity formulation                                                                                                                                                        FL
Definition: modal formulation  that formulates  that the  meaning of its embedded logical formulation  is 
true in all possible worlds
Concept Type: logical formulation kind
Reference Scheme: the logical formulation  that is embedded in the necessity formulation
obligation formulation                                                                                                                                                        FL
Definition: modal formulation  that formulates  that the  meaning of its embedded logical formulation  is 
true in all acceptable worlds
Concept Type: logical formulation kind
Reference Scheme: the logical formulation  that is embedded in the obligation formulation
Example: A rental may be open only if an estimated rent al charge is provisionally charged for the rental".  
The same rule can be stated this way:  “It is prohibited that a rental is  open if an estimated 
rental charge is not provisionally charged for the rental.”   
Both statements can be fo rmulated in the same way:  
 The rule is a proposition meant by an obligation formulation.  
. The obligation formulation embeds a logical negation  
. . The logical operand of  the logical negation is a universal quantification.  
. . . The universal quantificati on introduces a first variable.  
. . . . The first variable ranges over the concept ‘rental’.  
. . . The universal quantification scopes over an implication.  
. . . . The consequent of the imp lication is an atomic formulation.  
. . . . . The atomic formulation is  based on the verb concept ‘rental
 is open’.  
. . . . . . The ‘rental ’ role is bound to the first variable.  
. . . . The antecedent of the implicat ion is an existential quantification.  
. . . . . The existential quantification introduces a second variable.  
. . . . . .  The second variable ranges ov er the concept ‘estim ated rental charge’.  
. . . . . The existential quantification scopes over a logical negation.  
. . . . . . The logical operand of the logical negation is an atomic formulation.  
. . . . . . . The atomic formulation is based on the verb concept  
                    ‘estimated rental charge  is provisionally charged for rental ’. 
. . . . . . . . The ‘estimated rental charge ’ role is bound to the second variable.  
. . . . . . . . The ‘rental ’ role is bound to the first variable.
154                 Semantics of Business Vocabulary and Business Rules, v1.3permissibility formulation FL
Definition: modal formulation  that formulates  that the  meaning of its embedded logical formulation  is 
permitted to be true
Concept Type: logical formulation kind
Reference Scheme: the logical formulation  that is embedded in the permissibility formulation
possibility formulation  FL
Definition: modal formulation  that formulates  that the  meaning of its embedded logical formulation  is 
true in some possible world
Concept Type: logical formulation kind
Reference Scheme: the logical formulation  that is embedded in the possibility formulation
Semantics of Business Vocabula ry and Business Rules, v1.3        15521.3.5 Logical Operations
Figure 21.7
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by  two different interpretations.  See Clause 13 and Annex C.
logical operation                                                                                                                                                                   FL
Definition: logical formulation  that formulates a meaning based on only the truth or falseness of the 
meanings of one or more other logical formulations (its logical operands )
Necessity: Each logical operation  has at least one logical operand .
Necessity: Each variable  that is free within a logical operand  of a logical operation  is free within 
the logical operation .
logical operand                                                                                                                                                                     FL
Definition: logical formulation  upon which a given logical operation  operates
Concept Type: rolebinary logical operationlo gica l oper ati on
equivalence
         mater ial  e quiva lencedisj uncti on
         incl usive disjunction
exclusive disjunction
implication
         m at er ial im p licatio n
nand for mulation
n o r fo rm u latio n
w hether -or-not formul ati onl ogi cal negatio nlogi cal  operand 1
logi cal  operand 2
consequent
inconsequentconsequentlogical operand
logical formulation
{equals  logical o peran d 1 }
{eq u a l s  logical op erand  2}{subsets  l ogica l  operand}
{subsets  l ogica l  operand}
111111. .*
1also:also:also:conjunction
antecedent
{eq uals  l o gi cal  ope rand 1}
{eq uals  l o gi cal  ope rand 2}
156                 Semantics of Business Vocabulary and Business Rules, v1.3logical operation  has  logical operand  FL
Definition: the logical operation  operates on the logical operand
binary logical operation  FL
Definition: logical operation  that operates on two logical operands
Necessity: Each binary logical operation  has exactly one logical operand 1 .
Necessity: Each binary logical operation  has exactly one logical operand 2 .
Note: Distinct roles are defined for the two operands of a binary logical operation even though there 
is no significant difference betw een the roles for some operations , such as for co njunction. The 
one distinction that remains, how ever, is that the roles are dist inct from each ot her, and this 
distinction is important where an operation has the same logical formulation filling both roles, 
such as in ‘ p and p’ or ‘ p if and only if p’.
logical operand 1  FL
Definition: logical operand  that is the first of at least two operands to a logical operation
Concept Type: role
Necessity: Each logical operation  has at most one logical operand 1 .
logical operand 2  FL
Definition: logical operand  that  is the second of at least two operands to a logical operation
Concept Type: role
Necessity: Each logical operation  has at most one logical operand 2 .
binary logical operation  has  logical operand 1  FL
Definition: the binary logical operation  operates on the logical operand 1
binary logical operation  has  logical operand 2  FL
Definition: the binary logical operation  operates on the logical operand 2
conjunction  FL
Definition: binary logical operation  that formulates that the meaning of each of its logical operands  is 
true
Concept Type: logical formulation kind
Reference Scheme: the logical operand 1  of the conjunction  and the logical operand 2  of the conjunction
disjunction  FL
Definition: binary logical operation  that formulates that the meanin g of at least one of its logical  
operands  is true
Concept Type: logical formulation kind
Synonym: inclusive disjunction
Reference Scheme: the logical operand 1  of the disjunction  and the logical operand 2  of the disjunction
equivalence  FL
Definition: binary logical operation  that formulates that the meaning of its logical operands  are either 
all true or all false
Concept Type: logical formulation kind
Semantics of Business Vocabula ry and Business Rules, v1.3        157Synonym: material equivalence
Reference Scheme: the logical operand 1  of the equivalence  and the logical operand 2  of the equivalence
exclusive disjunction                                                                                                                                                         FL
Definition: binary logical operation  that formulates that the meaning of one logical operand  is true and 
the meaning of the other logical operand  is false
Concept Type: logical formulation kind
Reference Scheme: the logical operand 1  of the exclusive disjunction  and the logical operand 2  of the 
exclusive disjunction
implication                                                                                                                                                                               FL
Definition: binary logical operation  that operates on an antecedent  and a consequent  and that 
formulates that the meaning of the consequent  is true if the meaning of the antecedent  is 
true
Concept Type: logical formulation kind
Synonym: material implication
Necessity: Each  implication  has exactly one antecedent .
Necessity: Each  implication  has exactly one consequent .
Reference Scheme: the antecedent  of the implication  and the consequent  of the implication
antecedent                                                                                                                                                                              FL
Definition: logical operand  that  is the condition considered by a logical operation  such as an 
implication  (e.g., what is meant by the p in “if p then q”)
Concept Type: role
consequent                                                                                                                                                                             FL
Definition: logical operand  that is the implied or result operand to a logical operation  such as an 
implication  (e.g., what is meant by the q in “if p then q”)
Concept Type: role
implication  has antecedent                                                                                                                                             FL
Definition: the antecedent  is the logical operand 1  of the implication
implication  has consequent                                                                                                                                           FL
Definition: the consequent  is the logical operand 2  of the implication
logical negation                                                                                                                                                                    FL
Definition: logical operation  that has exactly one  logical operand  and that formulates  that the meaning 
of the logical operand  is false
Concept Type: logical formulation kind
Necessity: Each  logical negation  has exactly one logical operand .
Reference Scheme: the logical operand  of the logical negation
158                 Semantics of Business Vocabulary and Business Rules, v1.3nand formulation  FL
Definition: binary logical operation  that formulates that the meanin g of at least one of its logical  
operands  is false 
Concept Type: logical formulation kind
Reference Scheme: the logical operand 1  of the nand formulation  and the logical operand 2  of the nand  
formulation
nor formulation  FL
Definition: binary logical operation  that formulates that the meaning of each of its logical operands  is 
false
Concept Type: logical formulation kind
Reference Scheme: the logical operand 1  of the nor formulation  and the logical operand 2  of the nor 
formulation
whether-or-not formulation  FL
Definition: binary logical operation  that has a consequent  and an inconsequent  and that formulates 
that the meaning the consequent  is true regardless of the meaning the inconsequent
Concept Type: logical formulation kind
Necessity: Each  whether-or-not formulation  has exactly one consequent .
Necessity: Each  whether-or-not formulation  has exactly one inconsequent .
Reference Scheme: the consequent  of the whether-or-not formulation  and the inconsequent  of the 
whether-or-not formulation
inconsequent  FL
Definition: logical operand  that is an operand irrelevant to the logical result of a logical operation  such 
as of a whether-or-not formulation
Concept Type: role
whether-or-not formulation  has consequent  FL
Definition: the consequent  is the logical operand 1  of the whether-or-not formulation
whether-or-not formulation  has inconsequent  FL
Definition: the inconsequent  is the logical operand 2  of the whether-or-not formulation
Semantics of Business Vocabula ry and Business Rules, v1.3        15921.3.6 Quantifications
Figure 21.8
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by  two different interpretations.  See Clause 13 and Annex C.
quantification                                                                                                                                                                        FL
Definition: logical formulation  that introduces a variable  and that  has either the meaning: all referents 
of the variable satisfy a scope formulation ; or the meaning: a bounded number of referents of 
the variable  exist and satisfy a scope  formulation , if there is one
Note: A referent of the introduced variable satisfies a scope formulation if the meaning formulated 
by the scope formulation is true with every occu rrence of the variable interpreted as referring 
to the referent.
Note: If a quantification scopes over no logical form ulation, the meaning is that the bounded number 
of referents exist.
Note: Quantifications other than universal quantif ication and existential quantification involve 
cardinalities in a way that requires distinguishability of the things a variable refers to - a means to determine when one thing is not the same thing as another thing.  For example, the  
quantification
at-least-n q uantification
at-most-n quantification
at-most-one quantificationnonnegative integer
exactly-n quanti ficati on
exactly-o ne quan tificationexistential quantification
numeric range quantificationvariablelogical formulation
universal q uantificatio nintroducesscopes
over
cardinalityminimum
cardinalityminimum
cardinality
maximum
ca rd in ality maximum
cardinality11
11
11 0..10..1scope formulation
160                 Semantics of Business Vocabulary and Business Rules, v1.3quantification meant by “at least 2”  in “EU-Rent owns at least 2 cars” means that there exists a 
first car and a second car and th e first car is not the second car  - the two cars are distinct.   
Physical things tend to be distinguished intui tively by having different physical locations at 
any point in time, but abstract things are indi stinguishable without distinguishing properties.  
Reference schemes provide distinguishability and are often particularly important for abstract 
things.
Necessity: Each  quantification  introduces exactly one variable .
Necessity: Each  variable  is introduced by at most one quantification .
Necessity: Each quantification  scopes over  at most one logical formulation .
Necessity: A variable  that is free within a logical formulation  that is scoped over by a 
quantification  is free within the quantification  if and only if the quantification  does not 
introduce  the variable .
Necessity: A variable  that is free within a logical formulation  that restricts  a variable  that is 
introduced by  a quantification  is free within  the quantification  if and only if the  
quantification  does not introduce  the variable .
Example: “Each car model is supplied by a car manufacturer”.  
The proposition is meant by a universal quantification.  
. The universal quantification introduces a first variable.  
. . The first variable ranges over the concept ‘car model’.  
. The universal quantification scopes over an existential quantification.  
. . The existential quantification introduces a second variable.  
. . . The second variable ranges over the concept ‘car manufacturer’.  
. . The existential quantification scopes over an atomic formulation.  
. . . The atomic formulation is based on the verb concept  
                    ‘car manufacturer  supplies car model ’. 
. . . . The ‘car manufacturer ’ role is bound to the second variable.  
. . . . The ‘car model ’ role is bound to the first variable.
quantification  introduces variable  FL
Definition: the quantification  binds the variable  such that it is not free within the quantification
Note: For each referent of the variable the scope formul ation, if there is one, is considered with every 
occurrence of the variable interpreted as referring to the referent.
quantification  scopes over logical formulation  FL
Definition: each referent of the variable introduced by the quantification  satisfies the logical  
formulation  if the meaning formulated by the scope formulation is true with every occurrence 
of the variable interpreted as referring to the referent 
Synonymous Form: quantification  has scope formulation
Note: A quantification  other than a universal quantification  does not necessarily scope over a 
logical formulation (e.g., formulation of “some customer exists” can simply be an existential 
quantification introducing a variable that ranges over the concept ‘customer’).
Note: If a quantification scopes over a logical formulation, the variable introduced by the 
quantification is a free variable of that logical formulation, except in the rare case of a vacuous 
quantification. 
scope formulation  FL
Definition: logical formulation  that a given  quantification  scopes over  
Concept Type: role
Semantics of Business Vocabula ry and Business Rules, v1.3        161universal quantification                                                                                                                                                    FL
Definition: quantification  that scopes over a logical formulation  and that  has the meaning: for each 
referent of the variable  introduced by the quantification  the meaning formulated by the 
logical formulation  for the referent is true
Concept Type: logical formulation kind
Necessity: Each universal quantification  scopes over  a logical formulation .
Reference Scheme: the logical formulation  that is scoped over by the universal quantification  and the 
variable  that is introduced by the universal quantification  
existential quantification                                                                                                                                                    FL
Definition: at-least-n quantification  that has the minimum cardinality  1 
Note: An existential quantification, unlike othe r at-least-n quantifications, does not require 
distinguishability of referents.
Reference Scheme: the set of logical formulations  that are scoped over by the existential quantification  
and the variable  that is introduced by the existential quantification  
maximum cardinality                                                                                                                                                          FL
Definition: nonnegative integer  that is an upper bound in a  quantification  (such as an  
at-most-n quantification )
Concept Type: role
minimum cardinality                                                                                                                                                           FL
Definition: nonnegative integer  that is a lower bound in a  quantification  (such as an  
at-least-n quantification )
Concept Type: role
Concept Type:
at-least-n quantification                                                                                                                                                    FL
Definition: quantification  that has a minimum cardinality  and that  has the meaning: the number of 
referents of the variable  introduced by the quantification  that exist and that satisfy a scope  
formulation , if there is one, is not less than the minimum cardinality , and if the minimum  
cardinality  is greater than one, the referents are distinct  logical formulation kind
Note: For a minimum cardinality of 1, distinctness of referents is irrelevant.
Necessity: Each at-least-n quantification  has exactly one minimum cardinality . 
Necessity: The minimum cardinality  of each at-least-n quantification  is a positive integer . 
Reference Scheme: the minimum cardinality  of the at-least-n quantification  and the set of logical  
formulations  that are scoped over by the at-least-n quantification  and the variable  that 
is introduced by the at-least-n quantification  
at-least-n quantification  has minimum cardinality                                                                                               FL
Definition: the at-least-n quantification  is satisfied by the minimum cardinality  or greater
162                 Semantics of Business Vocabulary and Business Rules, v1.3at-most-n quantification  FL
Definition: quantification  that has a maximum cardinality  and that  has the meaning:  the number of 
distinct referents of the variable  introduced by the quantification  that exist and that satisfy a 
scope formulation , if there is one, is not greater than the maximum cardinality
Concept Type: logical formulation kind
Necessity: Each at-most-n quantification  has exactly one maximum cardinality . 
Necessity: The maximum cardinality  of each at-most-n quantification  is a positive integer . 
Reference Scheme: the maximum cardinality  of the at-most-n quantification  and the set of logical  
formulations  that are scoped over by the at-most-n quantification  and the variable  that 
is introduced by the at-most-n quantification  
Example: “Each rental must have at most three additional dr ivers.” See the introduc tion to Clause 21 for 
a semantic formulation of this rule.
at-most-n quantification  has maximum cardinality  FL
Definition: the at-most-n quantification  is satisfied by the maximum cardinality  or less
at-most-one quantification  FL
Definition: at-most-n quantification  that has the maximum cardinality  1
Note: A number of referents is at most one if and only if every referent is the same referent.
Reference Scheme: the set of logical formulations  that are scoped over by the at-most-one quantification  
and the variable  that is introduced by the at-most-one quantification  
exactly-n quantification  FL
Definition: quantification  that has a cardinality  and that  has the meaning: the numb er of referents of the 
variable  introduced by the quantification  that exist and that satisfy a scope formulation , if 
there is one, equals the cardinality
Necessity: Each exactly-n quantification  has exactly one cardinality . 
Necessity: The cardinality  of each exactly-n quantification  is a positive integer . 
Reference Scheme: the cardinality  of the exactly-n quantification  and the set of logical formulations  that 
are scoped over by the exactly-n quantification  and the variable  that is introduced by 
the exactly-n quantification
Note: An exactly-n quantification  is logically equivalent to a conjunction  of an at-least-n  
quantification  and an at-most-n quantification  using the cardinality  as minimum  
cardinality  and maximum cardinality  respectively.
exactly-n quantification  has cardinality  FL
Definition: the exactly-n quantification  is satisfied only by the cardinality  
exactly-one quantification  FL
Definition: exactly-n quantification  that has the cardinality  1
Note: A number of referents is exactly one if and only if there is a referent and every referent is that 
same referent. 
Concept Type: logical formulation kind
Reference Scheme: the set of logical formulations  that are scoped over by the exactly-one quantification  
and the variable  that is introduced by the exactly-one quantification  
Semantics of Business Vocabula ry and Business Rules, v1.3        163numeric range quantification                                                                                                                                         FL
Definition: quantification  that has a minimum cardinality  and a maximum cardinality  greater than the 
minimum cardinality  and that  has the meaning: the number of referents of the variable  
introduced by the quantification  that exist and that satisfy a scope formulation , if there is 
one, is not less than the minimum cardinality  and is not greater than the maximum  
cardinality
Concept Type: logical formulation kind
Necessity: Each numeric range quantification  has exactly one maximum cardinality .
Necessity: Each numeric range quantification  has exactly one minimum cardinality . 
Necessity: The minimum cardinality  of each numeric range quantification  is less than the 
maximum cardinality  of the numeric range quantification . 
Reference Scheme: the minimum cardinality  of the numeric range quantification  and the maximum  
cardinality  of the numeric range quantification  and the set of logical formulations  that 
are scoped over by the numeric range quantification  and the variable  that is 
introduced by the numeric range quantification  
Note: A numeric range quantification  is logically equivalent to a conjunction  of an at-least-n  
quantification  and an at-most-n quantification  using the minimum cardinality  and 
maximum cardinality  respectively.
numeric range quantification  has maximum cardinality                                                                                    FL
Definition: the numeric range quantification  cannot be satisfied by a number greater than the 
maximum cardinality
numeric range quantification  has minimum cardinality                                                                                     FL
Definition: the numeric range quantification  cannot be satisfied by a number less than the minimum  
cardinality
21.3.7 Objectifications
Figure 21.9
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by  two different interpretations.  See Clause 13 and Annex C.bi ndabl e tar getl ogi cal fo rmul ati on
objectifi cati onconsi ders
bin d s to
11
is bound to
164                 Semantics of Business Vocabulary and Business Rules, v1.3objectification  FL
Definition: logical formulation  that involves a bindable target  and a considered logical formulation  
and that formulates  the meaning: the thing to which the bindable target  refers is a state of 
affairs  to which the meaning of the considered logical formulation  corresponds
Concept Type: logical formulation kind
Note: An objectification is similar to an instantiation formulation in that it is satisfied by a 
correspondence of a referent thing to a meaning. For an instantiation formulation the meaning is a concept. For an objectification the meaning is a proposition.
Necessity: Each objectification
 considers  exactly one logical formulation .
Necessity: Each objectification  binds to  exactly one bindable target .
Necessity: Each variable  that is bound to  an objectification  is free within the objectification .
Necessity: Each variable  that is free within the logical formulation  that is considered by  an 
objectification  is free within the objectification .
Reference Scheme: the bindable target  that is bound to  the objectification  and the logical formulation  that 
is considered by  the objectification
Example: ‘late return’ defined as “actuality that a given rental is returned late”.  
The concept ‘late return’ is de fined by a closed projection.  
. The projection is on a first variable.  
. . The first variable ranges over the concept ‘actuality’.  
. The projection has an auxiliary variable.  
. . The auxiliary variable rang es over the concept ‘rental’.  
. The projection is constr ained by an objectification.  
. . The objectification binds to the first variable.  
. . The objectification consid ers an atomic formulation.  
. . . The atomic formulation is based on the characteristic ‘rental  is returned late’.  
. . . . The ‘rental ’ role is bound to the auxiliary variable.
Example: “EU-Rent reviews each corpor ate account at EU-Rent Headquarters”.  
The statement above could be formulated  using a ternary verb concept ‘company  reviews 
account  at place ’, but such a verb concept is not like ly represented in a business vocabulary 
because it mixes two orthogonal binary verb concepts: ‘company  reviews account ’ and ‘state 
of affairs  occurs at place ’.  The formulation below uses the two binary verb concepts and 
employs an objectification to tie them together.  
The statement is formulated by a universal quantification.  
. The quantification intr oduces a first variable.  
. . The first variable ranges over  the concept ‘corporate account’.  
. The quantification scopes over  an existential quantification.  
. . The existential quantification introduces a second variable.  
. . . The second variable ranges over the concept ‘state of affairs’.  
. . . The second variable is restricted by an objectification.  
. . . . The objectification bi nds to the second variable.  
. . . . The objectification cons iders an atomic formulation.  
. . . . . The atomic formulation is based on the verb concept ‘company  reviews account ’. 
. . . . . . The ‘company ’ role is bound to the individual noun concept ‘EU-Rent’.  
. . . . . . The ‘account ’ role is bound to the first variable.  
. . The existential quantification scopes over an atomic formulation.  
. . . The atomic formulation is based on the verb concept ‘state of affairs  occurs at place ’. 
. . . . The ‘state of affairs ’ role is bound to the second variable.  
. . . . The ‘place ’ role is bound to the individual noun concept ‘EU-Rent Headquarters’.
Semantics of Business Vocabula ry and Business Rules, v1.3        165Example: “EU-Rent has review ed each corporate account”.  
The verb concept ‘company  reviews account ’ can be used to form ulate the meaning of 
‘company  has reviewed account ’ (the present perfect tense) by using an objectification along 
with a generic verb concep t for the present perfect te nse, ‘state of affairs  has occurred’.  A 
formulation of the example statem ent is similar to that of the previous example but uses the 
verb concept ‘state of  affairs  has occurred’ rather th an ‘state of affairs  occurs at place ’.
Example: “EU-Rent privately re views each corporate account”.  
A formulation of the example stat ement is similar to that of the previous two examples, but 
uses the verb concept ‘state of affairs  occurs privately’.
Example: “If a rental car is returned late because th e car has a mechanical brea kdown ….”  In a possible 
formulation of this example, objectifications of “the car ha s a mechanical breakdown” and 
“the rental car is returned late” respectively formulate something for each role of the verb 
concept ‘actuality  causes actuality ’.
objectification  considers logical formulation                                                                                                          FL
Definition: the objectification  is of the state or event that  corresponds to the meaning of the logical  
formulation
objectification  binds to bindable target                                                                                                                     FL
Definition: the bindable target  indicates the referent stat e or event identified by the objectification
Synonymous Form: bindable target  is bound to objectification
21.3.8 Projecting Formulations
Figure 21.10
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by  two different interpretations.  See Clause 13 and Annex C.bindable targetprojection
projecting formulationprojection
binds to
aggregation formulation
question nominalization
answer nominalizationverb concept nominalizationnoun concept nominalization11
is bound to
166                 Semantics of Business Vocabulary and Business Rules, v1.3projecting formulation  FL
Definition: logical formulation  of a referent thing  considered with resp ect to a particular projection
Necessity: Each projecting formulation  has exactly one projection .
Necessity: Each projecting formulation  binds to  exactly one bindable target .
Necessity: Each variable  that is bound to  a projecting formulation  is free within the projecting  
formulation .
Necessity: Each variable  that is free within the projection  of a projecting formulation  is free within 
the projecting formulation .
Note: The concept ‘projecting formulation’ is abstract. See its specia lizations for semantics.
Example: See ‘ aggregation formulation ’, ‘question nominalization ’, and ‘ answer nominalization ’.
projecting formulation  has projection  FL
Definition: the projecting formulation  is based on the projection
projecting formulation  binds to bindable target  FL
Definition: the bindable target  indicates the referent thing  considered by the projecting formulation
Synonymous Form: bindable target  is bound to projecting formulation
aggregation formulation  FL
Definition: projecting formulation  that formulates the meaning: the thing to which the bindable target  
bound to the projecting formulation  refers is the result of the projection  of the projecting  
formulation
Note: The aggregation formulation is  used primarily to associate a variable with a set of things, 
involvements, or actualities that satisfy some cond ition. That is, it formulates natural language 
expressions of the form: “let <variable>  be the set of all things t such that <some condition 
involving t>,” so that <variable>  can then be used in other formulations regarding the set.  
The <condition involving t> often includes some free variable  introduced in the context in 
which the formulation is used.
Concept Type: logical formulation kind
Necessity: The projection  of each aggregation formulation  is on  exactly one variable .
Reference Scheme: the bindable target  that is bound to  the aggregation formulation  and the projection  of 
the aggregation formulation
Example: “The number of rental cars stored at a given branch must no t exceed the car storage capacity of 
the branch.”  This example cons iders the number of elements in a set (the set of rental cars 
stored at a branch).  The projecti on of an aggregation formulation is  used to define that set, and 
the aggregation formulation restricts the third variable below so that its referent is that set.
The statement is formulated by an obligation formulation.
. The obligation formulation embeds a first universal quantification.
. . The first universal quantification introduces a first variable.
. . . The first variable ranges over the concept ‘branch’.
. . The first universal quantification scopes over a second universal quantification.. . . The second universal quantification introduces a second variable.
. . . . The second variable rang es over the concept ‘number’.
. . . . The second variable is unitary.. . . . The second variable is restrict ed by a third universal quantification.
. . . . . The third universal quantification introduces a third variable.
Semantics of Business Vocabula ry and Business Rules, v1.3        167. . . . . . The third variable ranges over the concept ‘set’.
. . . . . . The third variable is unitary.
. . . . . . The third variable is rest ricted by an aggr egation formulation.
. . . . . . . The aggregation formulation binds to the third variable.. . . . . . . The aggregation fo rmulation considers a projection.
. . . . . . . . The projection is on a fourth variable.
. . . . . . . . . The fourth variable ranges over the concept ‘rental car’.. . . . . . . . The projection is constrained by an atomic formulation.
. . . . . . . . . The atomic formula tion is based on the verb concept
‘rental car
 is stored at branch ’.
. . . . . . . . . . The ‘rental car ’ role is bound to the fourth variable.
. . . . . . . . . . The ‘branch ’ role is bound to the first variable.
. . . . . The third universal quantification scopes over an atomic formulation.. . . . . . The atomic formulation is based on the verb concept ‘set
 has number ’.
. . . . . . . The ‘set ’ role is bound to the third variable.
. . . . . . . The ‘number ’ role is bound to the second variable.
. . . The second universal quantification scopes a fourth universal quantification.
. . . . The fourth universal quantification introduces a fifth variable.
. . . . . The fifth variable ranges ov er the concept ‘car  storage capacity’.
. . . . . The fifth variable is unitary.
. . . . . The fifth variable is rest ricted by an at omic formulation.
. . . . . . The atomic formulation is based on the verb concept
‘branch  has car storage capacity ’.
. . . . . . . The ‘branch ’ role is bound to the first variable.
. . . . . . . The ‘car storage capacity ’ role is bound to the fifth variable.
. . . . The fourth universal quantification scopes over a logical negation.
. . . . . The logical operan d of the logical negation is an atomic formulation.
. . . . . . The atomic formulation is based on the verb concept ‘number1 exceeds number2’.
. . . . . . . The ‘number1’ role is bound to the second variable.
. . . . . . . The ‘number2’ role is bound to the fifth variable.
noun concept nominalization   FL
Definition: projecting formulation  that  formulates the meaning:  the thing to which the bindable target  
bound to the projecting formulation  refers is a noun concept  that is defined by the 
projection  of the projecting formulation
Concept Type: logical formulation kind
Necessity: The projection  of each noun concept nominalization  is on  exactly one variable .
Note: In the case of variables being free within a projection of a noun concept nominalization, the 
projection is considered to define a noun concep t only in the context of there being a referent 
thing given for each free variable.
Note: Nouns are generally used to refer to things in the extension of the noun concept meant by the 
noun. Less commonly, a noun is used to mention a noun concept itself. This is referred to as a “mention” of the concept as opposed to a “use.”
Reference Scheme: the bindable target
 that is bound to  the noun concept nominalization  and the 
projection  of the noun concept nominalization  
168                 Semantics of Business Vocabulary and Business Rules, v1.3Example: “‘SUV’ is a vehicle type”.  In this example, the noun con cept ‘SUV’ is  
mentioned as a concept rather than used to refer to SUVs.  
The statement is formulated by  an existential quantification.  
. The existential quantification introduces a unitary variable.  
. . The unitary variable ranges over the concept ‘noun concept’.  
. . The unitary variable is restrict ed by a noun con cept nominalization.  
. . . The noun concept nominalization binds to the unitary variable.  
. . . The noun concept nominalization considers a projection.  
. . . . The projection is on one projection variable.  
. . . . . The projection variable ranges over the noun concept ‘SUV’.  
. The existential quantification scopes over an instantiation formulation.  
. . The instantiation formulation cons iders the concept ‘vehicle type’.  
. . The instantiation formulation binds to the unitary variable. 
Example: “No rental’s pi ck-up branch changes”.  
The statement is formulat ed by a logical negation.  
. The logical operand of the logical negation is an existential quantification.  
. . The quantification introduces a first variable.  
. . . The first variable ranges  over the concept ‘rental’.  
. . The quantification scopes over a second existential quantification.  
. . . The quantification ranges over a second variable, which is unitary.  
. . . . The second variable ranges ov er the concept ‘unitary noun concept’.  
. . . . The second variable is restricted by a noun concept nominalization.  
. . . . . The noun concep t nominalization binds to the second variable.  
. . . . . The noun concept nomin alization considers a projection.  
. . . . . . The projection is on a third variable, which is unitary.  
. . . . . . . The third variable ranges  over the concept ‘pick-up branch’.  
. . . . . . The projection is constrained by an atomic formulation.  
. . . . . . . The atomic formulation is based on  the verb concept ‘ren tal has pick-up branch’.  
. . . . . . . The ‘rental ’ role binds to the first variable.  
. . . . . . . The ‘pick-up branch ’ role binds to the third variable.  
. . . The second quantification scopes over an atomic formulation.  
. . . . The atomic formulation is based on the verb concept ‘unitary noun concept * changes’.  
. . . . The ‘unitary noun concept *’ role binds to the second variable.  
(See C.1.6, Intensional Roles, about the verb concept ‘unitary noun concept * changes.’)
verb concept nominalization  FL
Definition: projecting formulation  that formulates the meaning: the thing to which the bindable target  
bound to the projecting formulation  refers is a verb concept  that is defined by the projection  
of the projecting formulation
Concept Type: logical formulation kind
Reference Scheme: the bindable target  that is bound to  the verb concept nominalization  and the  projection  
of the verb concept nominalization
Note: A verb concept nominalization formulates the (anonymous) verb concept defined by a 
projection.  In most uses of verb concept no minalizations, the bindable target is a unitary 
variable, and the effect is to de fine the variable to refer to the anonymous verb concept defined 
by the projection.  It is the only referent for which the verb concept nominalization will hold.
Note: In the case of variables bein g free within a projection of a verb concept nominalization, the 
projection is considered to define a verb concept only in the context of there being a referent thing substituted for each free variable.
Semantics of Business Vocabula ry and Business Rules, v1.3        169Note: More information about how a projection defines a verb concept is in the entry for ‘ closed  
projection  defines  verb concept ’.  A verb concept nominalization nominalizes only a verb 
concept, not its roles. 
Example: “Being established by a rental booking is a ch aracteristic attributed to each advance rental”.  
The characteristic expressed as “being established by a rental booking” is nominalized within 
the statement.  
The statement is formulated by a universal quantification.  
. The universal quantification introduces a first variable.  
. . The first variable ranges ov er the concept ‘advance rental’.  
. The universal quantification scopes over a first existential quantification.  
. . The first existential quantificat ion introduces a second variable.  
. . . The second variable ranges ov er the concept ‘characteristic’.  
. . . The second variable is restri cted by an atomic formulation.  
. . . . The atomic formulation is base d on the verb concept ‘characteristic  is attributed to thing ’. 
. . . . . The ‘characteristic ’ role is bound to the second variable.  
. . . . . The ‘thing ’ role is bound to the first variable.  
. . The first existential quantification scopes over a verb concept nominalization.  
. . . The verb concept nominalization binds to the second variable.  
. . . The verb concept nomina lization considers a projection.  
. . . . The projection is on a third variable.  
. . . . The projection is constrained by a second existential quantification.  
. . . . . The second existential quantif ication introduces a fourth variable.  
. . . . . . The fourth variable ranges over the concept ‘rental booking’.  
. . . . . The second existential quantification scopes over an atomic formulation.  
. . . . . . The atomic formulation is based on the verb concept  
                   ‘rental booking  establishes advanced rental ’. 
. . . . . . . The ‘rental booking ’ role is bound to the fourth variable.  
. . . . . . . The ‘advanced rental ’ role is bound to the third variable.
21.3.9 Nominalizations of Propositions and Questions
Figure 21.11
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by  two different interpretations.  See Clause 13 and Annex C.bindabl e tar getlo gical  fo rm u lati o n
pr opo si t i o n n om i nal i z at i o nconsi ders
bi n ds to1
1 i s bound to
170                 Semantics of Business Vocabulary and Business Rules, v1.3proposition nominalization  FL
Definition: logical formulation  that involves a bindable target  and a considered logical formulation  
and that formulates  the meaning: the thing to which the bindable target  refers is the 
proposition  that is formulated by the considered logical formulation
Concept Type: logical formulation kind
Necessity: Each proposition nominalization  considers  exactly one logical formulation .
Necessity: Each proposition nominalization  binds to  exactly one bindable target .
Necessity: Each variable  that is bound to  a proposition nominalization  is free within the 
proposition nominalization .
Necessity: Each variable  that is free within the logical formulation  that is considered by  a 
proposition nominalization  is free within the proposition nominalization .
Note: A closed logical formulati on means exactly one proposition. An open logical formulation does 
not mean any proposition. In the case of variables being free within a considered logical 
formulation, the formulation is considered to mean a proposition only in the context of there 
being a referent thing given for each free variable.
Note: The truth of a nominalized proposition is not relevant to the satisfaction of the proposition  
nominalization .
Reference Scheme: the bindable target  that is bound to  the proposition nominalization  and the logical  
formulation  that is considered by  the proposition nominalization
Example: “Each EU-Rent branch posts a sign sta ting that no pe rsonal checks ar e accepted by the 
branch”.  
The statement is formalized by  a universal quantification.  
. The universal quantification is on a first variable.  
. . The variable ranges over the concept ‘EU-Rent branch’.  
. The universal quantification scopes over an existential quantification.  
. . The existential quantification introduces a second variable.  
. . . The second variable ranges over the concept ‘sign’.  
. . . The second variable is restricted by a second existential quantification.  
. . . . The second existential quantification introduces a third variable.  
. . . . . The third variable ranges  over the concep t ‘proposition’.  
. . . . . The third variable is restricted by a proposition nominalization.  
. . . . . . The proposition nominalization binds to the third variable  
. . . . . . The proposition nominalization considers a logical negation.  
. . . . . . . The logical operand of the nega tion is a third existential quantification.  
. . . . . . . . The quantification  introduces a fourth variable.  
. . . . . . . . . The variable ranges  over the concept ‘personal check’.  
. . . . . . . . The quantification sc opes over an atomic formulation.  
. . . . . . . . . The atomic formulation is based on the verb concept  
‘branch  accepts monetary instrument ’. 
. . . . . . . . . . The ‘branch ’ role is bound to the first variable.  
. . . . . . . . . . The ‘monetary instrument ’ role is bound to the fourth variable.  
. . . . The second existential quantification scopes over an atomic formulation.  
. . . . . The atomic formulation is based on the verb concept ‘sign  states proposition ’. 
. . . . . . The ‘sign ’ role is bound to the second variable.  
. . . . . . The ‘proposition ’ role is bound to the third variable.  
. . The first existential quantification scopes over an atomic formulation.  
. . . The atomic formulation is based on the verb concept ‘branch  posts sign ’. 
Semantics of Business Vocabula ry and Business Rules, v1.3        171. . . . The ‘branch ’ role is bound to the first variable.  
. . . . The ‘sign ’ role is bound to the second variable. 
proposition nominalization  considers logical formulation                                                                               FL
Definition: the proposition nominalization  nominalizes the proposition whose meaning is formulated by 
the logical formulation
proposition nominalization  binds to bindable target                                                                                          FL
Definition: the bindable target  indicates the referent proposition identified by the proposition  
nominalization
Synonymous Form: bindable target  is bound to proposition nominalization  
question nominalization
Definition: projecting formulation  that formulates the meaning: the thing to which the bindable target  
bound to the projecting formulation  refers is the question  that is meant by the projection  of 
the projecting formulation
Concept Type: logical formulation kind
Note: See ‘ closed projection  means  question ’ for an explanation and ex amples of how questions 
are formulated.
Note: A closed projection means at  most one question. In the case of variables being free within a 
projection, the projection is cons idered to mean a question only in the context of there being a 
referent thing given for each free variable.
Reference Scheme: the bindable target  that is bound to  the question nominalization  and the projection  of 
the question nominalization
Example: “An agent asks each customer what  car model the customer prefers ”. 
The statement is formulated by a universal quantification.  
. The quantification intro duces a first variable.  
. . The first variable ranges over the concept ‘customer’.  
. The quantification scopes over an existential quantification.  
. . The existential quantification introduces a second variable.  
. . . The second variable ranges over the concept ‘agent’.  
. . The existential quantification scopes over a second existential quantification.  
. . . The second existential quantifi cation introduces a third variable.  
. . . . The third variable ranges over the concept ‘question’.  
. . . . The third variable is rest ricted by a question nominalization.  
. . . . . The question nominalization binds to the third variable.  
. . . . . The question nominalization considers a projection.  
. . . . . . The projection is on a fourth variable.  
. . . . . . . The variable ranges  over the concept ‘car model’.  
. . . . . . The projection is constr ained by an atomic formulation.  
. . . . . . . The atomic formulation is based on the verb concept ‘person  prefers car model ’. 
. . . . . . . . The ‘person ’ role is bound to the first variable.  
. . . . . . . . The ‘car model ’ role is bound to the fourth variable.  
. . . The second existential quantification  scopes over an atomic formulation.  
. . . . The atomic formulation is based on the verb concept ‘person1 asks person2 question ’. 
. . . . . The ‘person1’ role is bound to the second variable.  
. . . . . The ‘person2’ role is bound to the first variable.  
. . . . . The ‘question ’ role is bound to the third variable.
172                 Semantics of Business Vocabulary and Business Rules, v1.3answer nominalization
Definition: projecting formulation  that formulates the meaning: the thing to which the bindable target  
bound to the projecting formulation  refers is a proposition  that is true and that completely 
and correctly answers th e question meant by the projection  of the projecting formulation
Concept Type: logical formulation kind
Note: See ‘ closed projection  means  question ’ for an explanation and examples of how questions 
are formulated.
Note: In the case of variables being free within a projection, the proj ection is considered to mean a 
question only in the context of  there being a referent thi ng given for each free variable.
Note: A thing referred to by a bindable target b ound to an answer nomina lization is a satisfactory 
proposition if it correctly and completely ho lds the result of the answer nominalization’s 
projection. A satisfying proposition incorporates  the meaning formulated  by the projection in 
the context of there being a referent thing gi ven for each free variable of the projection.  
Further, the satisfying propositio n refers to each referent of each variable in the projection. If 
the projection result has multiple elements, a satisfying proposition holds them all, conjunctively.  If the projection result is empt y, a satisfying projection indicates that it is 
empty.
Note: Each reference in a satisfying answer should use a defined reference scheme.Reference Scheme: the bindable target
 that is bound to  the answer nominalization  and the projection  of 
the answer nominalization
Example: “An agent tells each customer what sp ecial offer is available to the customer”.  
The statement is formulated by a universal quantification.  
. The quantification intr oduces a first variable.  
. . The first variable ranges over the concept ‘customer’.  
. The quantification scopes over  an existential quantification.  
. . The existential quantification introduces a second variable.  
. . . The second variable ranges over the concept ‘agent’.  
. . The existential quantification scopes over a second existential quantification.  
. . . The second existential quantification introduces a third variable.  
. . . . The third variable ranges over the concept ‘proposition’.  
. . . . The third variable is rest ricted by an answer nominalization.  
. . . . . The answer nominalizati on binds to the third variable.  
. . . . . The answer nominali zation considers a projection.  
. . . . . . The projection is on a fourth variable.  
. . . . . . . The variable ranges over the concept ‘special offer’.  
. . . . . . The projection is constrained by an atomic formulation.  
. . . . . . . The atomic formulation is ba sed on the verb concept ‘special offer  is available to  
                                customer ’. 
. . . . . . . . The ‘special offer ’ role is bound to the fourth variable.  
. . . . . . . . The ‘customer ’ role is bound to the first variable.
. . . The second existential quantification scopes over an atomic formulation.  
. . . . The atomic formulation is based on the verb concept ‘person1 tells person2 proposition ’. 
. . . . . The ‘person1’ role is bound to the second variable.  
. . . . . The ‘person2’ role is bound to the first variable.  
. . . . . The ‘proposition ’ role is bound to the third variable.  
 
Semantics of Business Vocabula ry and Business Rules, v1.3        173If exactly two special offers (Gold Customer  Discount and Free On e-level Upgrade) are 
available to a customer having customer id ‘987 6’, a satisfying answer fo r that customer would 
be the proposition meant by the st atement: “The special offers av ailable to the customer having 
the customer id ‘9876’ are the Gold Customer Discount and the Free One-level Upgrade.” 
21.4 Projections
Figure 21.12
This diagram shows the SBVR XMI Metamodel and SBVR vocabulary by  two different interpretations.  See Clause 13 and Annex C.
projection                                                                                                                                                                                FL
Definition: semantic formulation  that introduces one or more variables corresponding to involvements 
in actualities and that  is possibly constrained by a logical formulation and that  projects one 
or more of those variables
Necessity: Each projection  is on  at least one variable .
Necessity: Each projection  is constrained by  at most one logical formulation .variable
auxiliary variable projectionlogical form ulation
bag projection
closed projectionset projectionverb concept role
positive integermaps to
auxiliary 
variableis on
verb conceptprojection
position
noun conceptdefinesclosed semantic formulationis in
constrains
definitionformalizes0..10. . 1
1..*
0..11projection 
variable
constraining 
formulation
questionmeans
0..10.. 1
defines0..1
174                 Semantics of Business Vocabulary and Business Rules, v1.3Necessity: A variable  that is free within a logical formulation  that constrains a projection  is free 
within the projection  if and only if the projection  is not on the variable  and the variable  
is not an auxiliary variable  of the projection .
Necessity: No projection  is a logical formulation .
Necessity: A variable  that is in a projection  is not free within  the projection .
Necessity: A variable  that is free within  a logical formulation  that restricts  another  variable  that is 
in a projection  is free within  the projection .
Necessity: A variable  that is free within  a logical formulation  that restricts  an auxiliary variable  of a 
projection  is free within  the projection  if and only if the  variable  is not the  auxiliary  
variable .
Note: A restriction on a variable introduced by a projection cannot involve any other variable 
introduced by the projection.
Reference Scheme: the set of variables  that are in  the projection  and the set of auxiliary variables  of the 
projection  and the set of logical formulations  that constrain the projection
Note: A projection is a structure of meaning used in  formulating different kind s of meanings. Each is 
explained separately.  See the following entries:  ‘ closed projection  defines  noun concept ’,
‘closed projection  defines  verb concept ’, and ‘ closed projection  means  question ’. Also, 
projections are incorporated into pr ojecting formulations, which include ‘ aggregation 
formulation ’,‘noun concept nominalization ’,‘verb concept nominalization ’,‘question 
nominalization ’, and ‘ answer nominalization ’ each of which is explained separately with 
examples in previous sub clauses.
Note: A projection introduces one or more variables corresponding to involvements in actualities.  If 
the projection is constrained by a logical formulation, then for each combination of variables, 
one referent for each variable, the actuality is th at the meaning of the constraining formulation 
is true.  If the projection has no constraini ng formulation, then fo r each combination of 
variables, one referent for each variable, the actuality is that the referents exist.  
 That is, the basic meaning of a projection is a verb concept in which all of the variables 
introduced by the projection correspond to roles.   The basic meaning corresponds to actualities 
for which the following proposition holds:  
t
1 is a valid referent of v1 
[ AND t2 is a valid referent of v2 
... 
AND tn is a valid referent of vn ] 
[ AND S(t1, ..., tn) ] 
where v1, ..., vn are the variables introduced by the projection, t1, ..., tn are things, and S(t1, ..., 
tn) is the proposition formulated by the logical formulation that constrains the projection, if 
any, with those things substituted for the occurrences of the corresponding variables.  
 The meaning of a projection in some uses, ho wever, can be restricted to refer to the 
involvements of the things in the roles (denoted by the projection variables) in those actualities, or to the things that have those involvements.
Note: Projections introduce variables in two ways:  projection variables (varia bles that the projection 
‘is on’) and auxiliary variables.  Both correspond to involvements in the actualities that correspond to the basic meaning, but the result of a projection includes only the involvements that correspond to the projectio n variables.  Auxiliary variab les are used in selecting the 
Semantics of Business Vocabula ry and Business Rules, v1.3        175actualities that correspond to the projection, but are not part of the intent of the projection 
itself.
projection  is on variable                                                                                                                                                   FL
Definition: the projection  introduces  the variable  such that satisfying referents of the variable  are in the 
result of the projection
Synonymous Form: variable  is in projection
Synonymous Form: projection  has projection variable
Necessity: No variable  that is in a projection  is introduced by  a quantification .
projection  has auxiliary variable                                                                                                                                   FL
Definition: the auxiliary variable  is introduced by the projection , but is left out of the result of the 
projection  thereby giving the possibility of duplicates in a result
Necessity: No auxiliary variable  is introduced by  a quantification .
Necessity: No projection  is on  an auxiliary variable .
Necessity: Each  projection  that has an auxiliary variable  is constrained by  a logical formulation .
logical formulation  constrains projection                                                                                                                 FL
Definition: the logical formulation  determines which referents of the variables introduced by the 
projection  are in the result of the projection  
Synonymous Form: projection  has constraining formulation
Note: A logical formulation that cons trains a projection restricts the resu lts of the projection.  If there 
is no constraining logical formulation, then there is no restriction other than what is on variables in the projection.
auxiliary variable                                                                                                                                                                  FL
Definition: variable  that is introduced by a projection , but which is left out of the result of the projection  
thereby giving the possibili ty of duplicate results
Necessity: Each auxiliary variable  is of exactly one projection .
Reference Scheme: a projection  that has the auxiliary variable  and a projection position  of the auxiliary  
variable  and the set of  concepts  that are ranged over by  the auxiliary variable  and the 
set of logical formulations  that restrict  the auxiliary variable  and whether the  auxiliary  
variable  is unitary
projection position                                                                                                                                                              FL
Definition: positive integer  that distinguishes a variable  introduced by a projection from others 
introduced by th e same projection
Concept Type: role
variable  has projection position                                                                                                                                    FL
Definition: the variable  is introduced by a projection  and has the unique projection position  among the 
set of variables introduced by that projection
Necessity: Each variable  has at most one projection position .
Necessity: Each variable  that is in a projection  has exactly one projection position .
Necessity: Each auxiliary variable  has exactly one projection position .
176                 Semantics of Business Vocabulary and Business Rules, v1.3set projection  FL
Definition: projection  that has no auxiliary variable
Example: A projection  formalizing the expressi on, “customers that are pr eferred,” is on a single 
variable  (customer). There is no auxiliary variable , so the result is necessarily a set.
bag projection  FL
Definition: projection  that has an auxiliary variable
Note: A bag projection treats the resulting set of  actualities as a set of the corresponding 
involvements of referents of the projection variables in roles in those actualities. A thing that participates in those involvements may participate in more than one involvement and therefore have multiple “occurrences” in th e projection result.  In many cases, the use of the projection 
reduces the set of involvements to the set of thi ngs involved (and ignores the fact of multiple 
occurrence).  But in some cases the distinguished involvements/occurrences are important.
Example: A projection
 formalizing the expression, “account balances  of customers that are preferred,” is 
on a variable  (account balance) and has an auxiliary variable  (customer).  Only balances are 
in the result, but there can be duplicates wh ere multiple customers have the same balance.
closed projection  FL
Definition: projection  that is a closed semantic formulation
Example: A projection  formalizing the expression, “customers that are preferred, ” is closed – there is no 
variable that is not introduced.  But within a formulation of the expre ssion, “Each branch must 
report the number of car models  offered by the branch,” the projection  of “car models offered 
by the branch” is open because it binds to a variable  (branch) that is in troduced outside of the 
projection .
closed projection  formalizes definition
Definition: the definition  conveys the meaning formulated by the closed projection  and the  closed  
projection  refers to the concepts represented in the definition
Example: The one concept ‘local car movement’ can be defined as “one-way car movement that is in-
area” or as “car movement that is in-area and that  is not round-trip.” Both definitions have the 
same meaning, but one is forma lized in reference to the noun concept ‘one-way  car movement’ 
(defined as “car movement that is not roun d-trip”) and the other in reference to the 
characteristic ‘car movement  is round-trip’. The two formulations are different but mean the 
same noun concept.
Necessity: Each closed projection  that formalizes  a definition  of a noun concept  defines  the noun  
concept .
Necessity: Each closed projection  that formalizes  a definition  of a verb concept  defines  the verb  
concept .
closed projection  defines noun concept  FL
Definition: the closed projection  is on exactly one variable and the closed projection  formulates a set 
of incorporated characteristic s sufficient to determine the noun concept
Necessity: Each  closed projection  that defines  a noun concept  is on  at most one  variable .
Necessity: If a closed projection  that defines  a noun concept  is a set projection  that is on  a 
variable  that is unitary  then the  noun concept  is an individual noun concept .
Note: A closed projection defines a noun concept by formulating a set of incorporated characteristics 
that determine the noun concept. These incorporated charact eristics include:
Semantics of Business Vocabula ry and Business Rules, v1.3        1771.  All characteristics of the ranged-over concept of the projection variable of the projection,  
if there is one.
2.  If a logical formulation restricts the proj ection variable, the meanin g of that formulation 
with respect to the projection variable.
3.  If the projection has a constraining formulation and the projection has no auxiliary 
variable, the meaning of the constraining formulation with respect to the projection 
variable.
4. If the projection has a constraining formulation and the projection has an auxiliary 
variable, the characteristic of being involved in an actuality that corresponds to the “basic 
meaning” of the projection.
Note: When a projection defines a noun concept, it restricts the basic meaning (the set of 
corresponding actualities) to the involvements in those actualities that are denoted by the projection variable, and further to the things participating in those involvements – the things that play the corresponding role.  If there are auxiliary variable s, a given thing may participate 
in more than one such involvement.  In many cases, however, the projection introduces only one variable and the actualities ar e of things having a particular  property. If a projection that 
defines a general concept has an auxiliary va riable, the general con cept incorporates the 
characteristic of being involved in  an actuality that also involv es a referent of the auxiliary 
variable, as if the auxiliary variable is existent ially quantified. The characterization is from the 
perspective of a referent of the auxiliary variable. 
Example: The general concept ‘wre cked car’ defined as “car that is disabled by an accident”
A closed projection defines the general concept.  
. The projection is on a first variable.  
. . The first variable rang es over the concept ‘car’.  
. The projection is constrained by  an existential quantification.  
. . The quantification is  on a second variable.  
. . . The second variable ranges  over the concept ‘accident’.  
. . The quantification scopes over an atomic formulation.  
. . . The atomic formulation is based on the verb concept ‘accident
 disables vehicle ’. 
. . . . The ‘accident ’ role is bound to the second variable.  
. . . .  The ‘vehicle ’ role is bound to the first variable.
closed projection  defines  verb concept
Definition: the closed projection  is on one variable for each role of the verb concept  and the closed  
projection  identifies enough character istics incorporated by the verb concept  that all of its 
incorporated characteris tics can be determined
Necessity: If a closed projection  defines  a verb concept  and the  closed projection  defines  a noun  
concept  then the  verb concept  is a characteristic  and the  role of the characteristic  is 
coextensive with  the noun concept .
Note: If a closed projectio n defines a verb concept, each variab le introduced by  the projection, 
including auxiliary variables, is understood as a point of involvement in actualities that are instances of the verb concept. If the projection has a constraining formulation, the meaning of 
the verb concept for each comb ination of referents, one for each variable, is the proposition 
meant by the logical formulation.  If no logical formulation cons trains the projection, then the 
meaning of the verb concept for each combination of referents is  that the refe rents all exist.
Note: A verb concept defined by a closed project ion incorporates the fo llowing characteristics:
1. All characteristics of the concept ‘ actuality
’.
2. Each instance of the verb concept involves exactly one thing in each role of the verb 
concept – see ‘ variable  maps to  verb concept role ’ below.
178                 Semantics of Business Vocabulary and Business Rules, v1.33. If the projection has a constraining formulation and the projection has no auxiliary 
variable, the meaning of the constraining formulation with  respect to the projection 
variables.
4. If the projection has a constraining formulation and the projection has an auxiliary 
variable, the meaning of the constraining formulation with  respect to the projection 
variables and of involving a given referent of  each auxiliary variable  of the projection in 
its corresponding role of the “base meaning.”
Example: The characteristic ‘car  is wrecked’ defined as “the car  is disabled by an accident.”  The closed 
projection given in the example under ‘ closed projection  defines  noun concept ’ above as 
defining ‘wrecked car’ also defines this characteristic.  The difference between the 
characteristic and the noun con cept is that the extension of the noun concept is the set of 
wrecked cars while the extension of  the characteristic is the set of  actualities that a given car is 
wrecked.  Elements of the two ex tensions are related one-to-one.
Example: The binary verb concept ‘accident  disables vehicle ’ defined as “the accident  causes the vehicle  
to be nonoperational”.
The binary verb concept is defined by a closed projection.  
. The projection is on a first variable.  
. . The first variable ranges  over the concept ‘vehicle’.  
. The projection is on a second variable.  
. . The second variable ranges  over the concept ‘accident’.  
. The projection is constrained by an existential quantification.  
. . The existential quantification is on a third variable.  
. . . The third variable is re stricted by an objectification.  
. . . . The objectification binds to the third variable.  
. . . . The objectification cons iders an atomic formulation.  
. . . . . The atomic formulation is based on the verb concept ‘vehicle  is nonoperational’.  
. . . . . . The ‘vehicle ’ role is bound to the first variable.  
. . The existential quantification scopes over an atomic formulation.  
. . . The atomic formulation is based on the verb concept ‘event  causes state of affairs ’. 
. . . . The ‘event ’ role is bound to the second variable.  
. . . .  The ‘state of affairs ’ role is bound to the third variable.
variable  maps to verb concept role  FL
Definition: the variable  is in a closed projection  that defines the verb concept  that has the verb 
concept role  such that for each element in the projection result the re ferent of the variable is 
involved in the verb concept role  in a corresponding actuality  in the extension  of the verb 
concept
Synonymous Form: verb concept role  is mapped from variable
Necessity: If a closed projection  defines  a verb concept  then each  role of the verb concept  is 
mapped from  exactly one  variable  that is in the closed projection  and each  variable  
that is in the closed projection  maps to  exactly one  role of the verb concept .
Necessity: A variable  maps to  a verb concept role  only if a  closed projection  that is on  the variable  
defines  a verb concept  that has the verb concept role .
Necessity: Each  variable  maps to  at most one  verb concept role .
Note: A verb concept role that is mapped from  a projection variable of a closed projection 
incorporates the following characteristics (which are the same as if a general concept is defined 
by the projection with the one modification that all other introduced variables are auxiliary):
1. All characteristics of the ranged-over concept of the variable, if there is one.
Semantics of Business Vocabula ry and Business Rules, v1.3        1792. If a logical formulation rest ricts the variable, the meaning of  that formulation with respect 
to the variable.
3.  If the projection has a constraining formulat ion, the characteristic of  being involved as a  
referent of the variable in a given actuality denoted by the constraining formulation.
Example: The ‘car ’ role of the characteristic ‘car  is wrecked’ in the example above under ‘ closed  
projection  defines  verb concept ’ is mapped from the one variable in the closed projection 
that defines the characteristic.  Note that the role incorporates the same characteristics as the 
noun concept ‘wrecked car’, and is  therefore coextensive with it.
Example: In the binary verb concept ‘accident  disables vehicle ’ in the example above under ‘ closed  
projection  defines  verb concept ’, the ‘accident ’ role is mapped from the first variable and 
the ‘vehicle ’ role is mapped from the second variable in the projection that defines the binary 
verb concept.
closed projection  means question
Definition: the closed projection  formulates the question  such that the result of the projection  answers 
the question
Necessity: Each  closed projection  means  at most one  question .
Note: A question using an interrogative operator such  as ‘what’, ‘when’, ‘whe re’, ‘why’, or ‘how’ is 
generally formulated by a projection on a variable  that ranges over a co ncept that matches the 
operator. The interrogative ‘what’ is often used with a designation of a noun concept such as in “What car is available?” in which case the variab le ranges over the noun concept ‘car’. For 
each of the other operators the variable ranges over  a noun concept fitting to that operator as if 
‘what’ had been used with a designation for that  concept. Examples of the correspondence of 
interrogative operators to noun concepts is shown below.  
    “When is a car available?”   What time  
   “How is a car driven?” What method  
   “Where is a car?”   What location  
   “Who can drive a car?”   What person  
   “Why is a car available?”  What cause  
 
Note that definition of these nouns (underlined above) is outside the scope of SBVR.  
However, the concept ‘cause’ is a role that rang es over the concept ‘actua lity’ so an answer to 
a ‘why’ question is often formulated using an objectification (the last example under ‘objectification
’ considers one actuality as a cause of another).
Note: A true/false question is typically nominalized using the interrogative op erator ‘whether’ as in 
“The customer asked whether a car is availabl e,” but is asked (in English) with no such 
operator:  “Is a car available?”.  The meaning of ‘whether’ in th is context is “What truth-value 
does this proposition have?”.  The formulation of such a question is a projection on a variable that ranges over a characteris tic type (here called ‘truth-val ue’) whose instances are the 
characteristics ‘ proposition
 is true ’ and ‘ proposition  is false ’.  The projection is constrained 
by the truth-value being that of the propo sition “a car is availa ble” formulated using 
proposition nominalization.
Example: “Is a car available”?  
The question is meant by a closed projection.  
. The projection is on a unitary variable.  
. . The variable ranges over  the concept ‘truth-value’.  
. The projection is constrained by a universal quantification.  
. . The universal quantification introduces a second unitary variable.  
180                 Semantics of Business Vocabulary and Business Rules, v1.3. . . The second variable ranges over the concept ‘proposition’.  
. . . The second variable is restricted by a proposition nominalization.  
. . . . The proposition nominalization binds to the second variable.  
. . . . The proposition nominalization considers an existential quantification.  
. . . . . The existential quantification introduces a third variable.  
. . . . . . The variable ranges over the concept ‘car’.  
. . . . . The existential quantification scopes over an atomic formulation.  
. . . . . . The atomic formulation is based on the verb concept ‘car  is available’.  
. . . . . . . The ‘car ’ role is bound to the third variable.
. . The universal quantification scopes over an atomic formulation.  
. . . The atomic formulation is based on the verb concept ‘proposition  has truth-value ’. 
. . . . The ‘proposition ’ role is bound to the second variable.  
. . . . The ‘truth-value ’ role is bound to the first variable. 
Note: An auxiliary variable of a closed projection th at means a question is relevant to formulating the 
meaning of the question, but the question is answered without identifying referents of the auxiliary variable.
__________________________________________________  
__________________________________________________
                                                                                                                      
Semantics of Business Vocabula ry and Business Rules, v1.3                                  18122 Index of Vocabulary Entries (Informative)
A
actuality  25
adopted definition 137adopting authority 139adopting authority adopts element of guidance from owning authority citing reference 140advice 99advice is derived from business policy 99advice of contingency 110advice of optionality 119advice of permission 118advice of possibility 110advice statement 102aggregation formulation  166answer nominalization 172antecedent 157aspect 89association 77assortment 83at-least-n quantification  161at-least-n quantification has minimum cardinality 161
at-most-n quantification  162at-most-n quantification has maximum cardinality  162
at-most-one quantification  162atomic formulation  150atomic formulation has role binding  150atomic formulation is based on verb concept  151attributive namespace 135attributive namespace is for subject concept 135attributive namespace is within vocabulary namespace 135authority 41authority authors guidance statement 139authority defines element of guidance 139authority has business jurisdiction over element of guidance 41auxiliary variable  175
B
bag projection  176behavioral business rule 118binary logical operation  156binary logical operation has logical operand 1  156binary logical operation has logical operand 2  156binary verb concept  52bindable target  148body of shared concepts 126body of shared concepts includes concept 126body of shared guidance 127body of shared guidance inclu des element of guidance 127
body of shared meanings 125body of shared meanings includes body of shared concepts 127
182                                                                                                    Semantics of Business Vocab ulary and Busine ss Rules, v1.3body of shared meanings includes body of shared guidance 127
body of shared meanings unites semantic community  126body of shared meanings1 contai ns body of chared meanings2  126
business policy 100business policy statement 102business rule 198business rule is derived from business policy 99
business vocabulary 128
C
cardinality  94categorization 80categorization scheme 81categorization scheme contains category 81categorization scheme is for general concept 81categorization type 81categorization type is for general concept 81category 45characteristic  43characteristic type 81characterization 83classification  82closed logical formulation  145closed logical formulation formalizes statement  146closed logical formulation means proposition  146closed projection  176closed projection defines noun concept  176closed projection defines verb concept 177closed projection formalizes definition 176
closed projection means question 179
closed semantic formulation  144closed semantic formulation formulates meaning 144comment 76communication content 132communication content is composed of representation 133community 39community has subcommunity 40community has URI 39concept 26concept has definition 73concept has designation 61concept has extension 31concept has facet 89concept has implied characteristic 45concept has instance 31concept has necessary  characteristic 44
concept incorporates characteristic  44concept of thing as composite 92concept of thing as continuant 92
                                                                                                                      
Semantics of Business Vocabula ry and Business Rules, v1.3                                  183concept of thing as developed 92
concept of thing as occurrent 92concept of thing as primitive 92concept of thing as unitary 92concept of thing existing dependently 92concept of thing existing independently 92concept type 81concept1 is coextensive with concept2  31concept1 specializes concept2  46conjunction 156consequent 157Context of Thing 86contextualized concept 86contingency statement 114
Ddefinite description 74
definition 73
Definition Origin 137
definition serves as designation  74definitional rule 109definitional business rule 110delimiting characteristic  45derivable concept 74description 75description portrays meaning 75descriptive example 75descriptive example illustrates meaning 76
designation 60designation context 59designation has signifier 61designation is implic itly understood  74
designation is in namespace 134disjunction  156document content 132
E
element  94element of governance 100element of governance is directly enforceable 100
element of guidance 28element of guidance authorizes state of affairs 35element of guidance is practicable 99element of guidance obligates state of affairs 35element of guidance prohibits state of affairs 35Elements of Concept System Structure 91enforcement level 118equivalence  156essential characteristic 44exactly-n quantification  162exactly-n quantification has cardinality  162exactly-one quantification  162
184                                                                                                    Semantics of Business Vocab ulary and Busine ss Rules, v1.3exclusive disjunction  157
existential quantification  161expression  22expression is unambiguous to speech community  58expression represents meaning 23extension  31extensional definition 74
F
facet 89fact  28Formal Logic and Mathematics Vocabulary 19formal representation 58fundamental concept 85
G
general concept  48general concept objectifies verb concept  84general verb concept  52guidance statement  101
I
icon 62implication  157implication has antecedent  157implication has consequent  157implied characteristic  45impossibility statement 111inconsequent  158individual noun concept  49individual verb concept  53informal representation 58information source 133instance  31instantiation formulation 151instantiation formulation binds to bindable target 152instantiation formulation considers concept  152integer  94intensional definition 74intensional definition uses delimiting characteristic  74is-facet-of proposition 89ISO 1087-1 (English) 19ISO 6093 Number Namespace 19ISO 639-2 (Alpha-3 Code) 20ISO 639-2 (English) 19is-property-of verb concept 78is-role-of proposition 88
                                                                                                                      
Semantics of Business Vocabula ry and Business Rules, v1.3                                  185K
Kind of Guidance Statement 101
L
language 40
logical formulation  145logical formulation constrains projection 175logical formulation kind 145logical formulation restricts variable 147logical negation 157logical operand  155logical operand 1  156logical operand 2  156logical operation 155logical operation has logical operand  156
M
maximum cardinality  161meaning 22Meaning and Representation Vocabulary  17meaning corresponds to thing 23message content 132minimum cardinality  161modal formulation  152modal formulation embeds logical formulation 153more general concept 45
N
name 62namespace 133namespace has URI 134namespace1 incorporates namespace2 133nand formulation  158necessary characteristic 44necessity formulation  153necessity statement 111non-necessity statement 114nonnegative integer  94non-obligation statement 123nonverbal designation 62nor formulation 158note 76note comments on meaning 76noun concept 47noun concept nominalization 167noun form 68number 94numeric range quantification  163numeric range quantification has maximum cardinality 163numeric range quantification has minimum cardinality  163
186                                                                                                    Semantics of Business Vocab ulary and Busine ss Rules, v1.3O
objectification  164
objectification binds to bindable target 165objectification considers logical formulation  165
objectified verb concept 84obligation formulation  153obligation statement 120operative business rule 117operative business rule has enforcement level 118operative business rule statement 120optionality statement 123owned definition 137owning authority 140
P
partitioning 81partitive verb concept 79part-whole verb concept 80permissibility formulation 154permission statement 122placeholder 65placeholder is at starting character position 69placeholder uses designation 69positive integer  94possibility formulation  154possibility statement 113preferred designation 63prohibited designation 63prohibition statement 121projecting formulation  166projecting formulation binds to bindable target 166projecting formulation has projection 166projection  173projection has auxiliary variable  175projection is on variable  175projection position  175property 24property association 78proposition  26proposition corresponds to state of affairs 32proposition is based on verb concept 52proposition is false 33proposition is necessarily true 33proposition is obligated to be false 34proposition is obligated to be true 34proposition is permitted to be true 34proposition is possibly true 34proposition is true 33
                                                                                                                      
Semantics of Business Vocabula ry and Business Rules, v1.3                                  187proposition nominalization  170
proposition nominalization binds to bindable target  171proposition nominalization considers logical formulation  171
Q
quantification 159quantification introduces variable  160quantification scopes over logical formulation  160quantity 93quantity1 equals quantity2  94quantity1 is less than quantity2  94question 27question nominalization 171
R
Real-world Numerical Correspondence 82reference 76reference points to information source 133reference scheme  53reference scheme extensionally uses verb concept role  54reference scheme is for concept  54reference scheme simply uses verb concept role 54reference scheme uses characteristic 55reference supports meaning 76remark 76representation 57Representation Formality 58representation has expression 57representation is in designation context 59representation is in subject field  60representation represents meaning 57representation uses vocabulary 129res 23res is sensory manifestation of signifier 36restricted permission statement 121restricted possibility statement 112role  48role binding 151role binding binds to bindable target  151role ranges over general concept  48rule 29rule statement 102rulebook 131rulebook has URI 132
S
SBVR Vocabulary 17, 19scope formulation  160segmentation 81semantic community 40semantic community has speech community 40semantic community shares understanding of concept 40
188                                                                                                    Semantics of Business Vocab ulary and Busine ss Rules, v1.3semantic formulation  144
sentential form 68set  94set has cardinality  95set projection  176signifier 61situation 87situational role 88speech community 40speech community adopts adopted definition citing reference 138speech community determines spee ch community representation set 130
speech community owns owned definition 137speech community owns vocabulary 128speech community regulates its usage of signifier 63speech community representation set 129speech community representation set includes representation 129speech community uses language 40speech community uses vocabulary 128starting character position 69state of affairs  24state of affairs involves thing in role  35state of affairs is actual  24statement 70statement denotes state of affairs  37statement expresses proposition  71statement of advice of permission 122statement of advice of possibility 113structural business rule  109structural rule  109structural rule statement 111subcommunity 39subject concept  78subject field  60
T
term 61term denotes thing 36terminological dictionary 130terminological dictionary expresses body of shared meanings 131terminological dictionary has URI 131terminological dictionary includes representation 130terminological dictionary presents vocabulary 131text 29thing  22thing has name 36thing is in set  94thing1 is thing2  24
                                                                                                                      
Semantics of Business Vocabula ry and Business Rules, v1.3                                  189U
UML 2 Infrastructure 20
unary verb concept 52Unicode Glossary 20Uniform Resource Iden tifiers Vocabulary 20
unitary noun concept 49unitary verb concept 52  universal quantification  161URI 30
V
variable  146variable has projection position  175variable is free within se mantic formulation  148
variable is unitary  147variable maps to verb concept role 178variable ranges over concept 147verb concept   50verb concept has role  51verb concept has verb concept wording 67verb concept nominalization  168verb concept objectification 84verb concept role 51verb concept role designation 64verb concept role has role binding  151verb concept wording 66verb concept wording has placeholder 69verb concept wording incorporates verb symbol 67verb concept wording is in namespace 134verb symbol 62viewpoint 89vocabulary 128vocabulary is designed for speech community 128vocabulary is expressed in language 128vocabulary is used to express body of shared meanings 129vocabulary namespace 134vocabulary namespace is derived from vocabulary 134vocabulary namespace is for language 134vocabulary namespace is specific to designation context 134vocabulary namespace is specific to subject field 135Vocabulary Registra tion Vocabulary 19
vocabulary1 incorporates vocabulary2 128
W
whether-or-not formulation  158whether-or-not formulation has consequent  158whether-or-not formulation has inconsequent  158
190                                                                                                    Semantics of Business Vocab ulary and Busine ss Rules, v1.3
Semantics of Business Vocabulary a nd Business Rules, v1.3        191Part III - Transformation to XMI Metamodel and the  
Metamodel’s Interpretation in Formal Logics
This part contains details on the transformation of the SBVR Vocabulary  (Clauses 8 through 21) to the SBVR XMI 
metamodel. It also presents the formal logi cs interpretation of the SBVR XMI Metamodel.
Clause 23 specifies how the SBVR XMI Metamodel is generated from th e Terminological entries in the SBVR 
Vocabulary  and the Vocabulary Registration Vocabulary  (Clauses 7 through 21). 
Clause 24 presents the formal logics  and mathematical underpinnings of th e SBVR XML Metamodel. A concept in 
Clauses 8 through 21 marked with the symbol ‘FL’ is  mapped to a formal logics concept in Clause 24.
Clause 25 lists supporting documents such as an SBVR XM I-based XML schema (XSD) fo r the SBVR XMI Metamodel. 
192  Semantics of Business Vocabula ry and Business Rules, v1.3
Semantics of Business Vocabula ry and Business Rules, v1.3        19323 SBVR’s Use of MOF and XMI
23.1 General
The SBVR XMI Metamodel (see sub clause  25.2) is a MOF-based metamodel that supports a MOF representation of the 
concepts represented by the SBVR vocabularies. The UML figur es in Clauses 8 through 21 show the SBVR vocabulary 
and the SBVR XMI Metamodel at the sa me time. This is because the vocabu lary used by people and the MOF-based 
metamodel reveal the same concept system. Conceptual integr ation across vocabularies and la nguages involves one set of 
concepts (one model) expres sed using different vocabularies or different languages.  
SBVR’s use of MOF and how the SBVR XMI Metamodel hand les certain semantic modeling challenges using MOF 2.0 
are described below. The SBVR XMI Metamodel is available as an XML document (see 25.2).  It is drawn from the text of Clauses 8 through 21.  UML Figures in those clauses illustra te the Metamodel using an interpretation explained in 23.2 
below.  This interpretation should not be confused with the 'Business Object Model' interpretation of the same figures 
explained in Annex C, which is based on a different pr ofile. An example model that instantiates the SBVR XMI 
Metamodel is then shown and explained.  Finally , the SBVR Content Model for SBVR is explained.
Models of business concepts, bu siness vocabularies and business  guidance can be communicated in terms of SBVR using 
XML documents that conform to the SBVR XMI XML schema  (see 25.3) created from th e SBVR XMI Metamodel (see 
25.2).
23.2 SBVR's Use of MOF
The following terms used in this clause are not words defined by SBVR.  Their meanings come from MOF 2.0.
How each of these is used with respect to SBVR is expl ained below. The UML figures in Clauses 8 through 11 use 
normal UML notation to show the SBVR XMI Metamode l except for custom notations described below. 
23.2.1 Metamodels
A model is a representation of facts. A model instantiates a metamodel which describes the structure and language by 
which facts are represented in models. A metamodel is itself a model which in stantiates the MOF model (the meta-
metamodel). The diagram below illustrates how SBVR  fits into the MOF metamodeling architecture.metamodel package association association end class attribute data type
model link element data value
194                 Semantics of Business Vocabulary and Business Rules, v1.3Figure 23.1 - SBVR Machine-Re adable File Relationships
The SBVR XMI Metamodel (see sub clause  25.2) instantiates the MOF model. It describes SBVR Content models, which 
represent facts built on SBVR co ncepts represented in the SBVR Vocabulary .
The SBVR XMI Metamodel does not include definitions, rules,  notes, examples or semantic formulations.  Rather, it 
mirrors the SBVR namespaces for those voc abularies.  It provides a MOF means of expression (classes and associations) 
where the SBVR vocabulary namespaces identify an English language means of expressi on (designations and verb 
concept wordings). Both use the same signifiers.  A result of  this alignment of the SBVR XMI Metamodel with the SBVR 
vocabulary is that knowledge of the vocabulary implies knowle dge of the Metamodel and vice versa. The SBVR XMI 
Metamodel is serialized as an XML document (see 25.2).
23.2.2 SBVR Content Models
SBVR Content models represent facts that  are about or within a body of shared meanings.  For example, facts about EU-
Rent’s concepts, rules, their representa tions and their semantic formulations can be represented in a SBVR Content 
model.  A thing represented in a model is identified by facts about the thing that satisfy a reference scheme.  An example 
SBVR Content model is shown in 23.4 belo w. SBVR Content models are often inco mplete representations of a body of 
shared meanings.  The size of a model de pends on what facts are being represented,  which can be as little as a single fact.
One particular SBVR Content model is the SBVR Content Mode l for SBVR (see sub clause 25.4), which is a model of 
SBVR in terms of itself.  It is described in sub clause 23.5 below.MOF
<<meta-metamodel>>
SBVR
<<metamodels>>
SBVR Model of SBVR
<<model>>(see 25.1)
(see 25.3)<<reflects representation>>
(see 23.2.1)<<instantiates>>
<<instantiates>>
<<models contents>>
(see 23.5)<<instantiates>>
Other MOF-based metamodels
(UML, CWM, ...)
<<instantiates>>
Other MOF-based SBVR models
(EU-Rent, ...) 
Vocabularies in
clauses 7 through 21
 Contents of clauses
7 through 21
Semantics of Business Vocabula ry and Business Rules, v1.3        195An SBVR Content Model instantiates the SB VR XMI Metamodel.  It represents a fact model , which combines a 
conceptual  schema  and a set of facts.  The conceptual schema is described by the SBVR model of SBVR. The facts are 
expressed in terms of the concepts in the conceptual sc hema and are limited to what is possible according to the 
conceptual schema.
All uses of the terms “ conceptual schema ” and “ fact model ” in this clause are as defined in sub clause 24.2.2.1.
23.3 MOF Model Elements for SBVR
The SBVR Vocabulary  is mapped to MOF elements that make up the SB VR XMI Metamodel.  It should not be construed 
from this one-way mapping that a MOF class is the same thin g as an SBVR concept or that there is any semantic 
equivalence between MOF and SBVR.
SBVR model content is represented in SBVR Content mode ls according to the SBVR XMI Metamodel. SBVR Content 
models instantiate the SBVR XMI Metamodel, not the UML Me tamodel. Another transform would be needed to represent 
SBVR model content using UML.
Both the mapping of the SBVR Vocabulary  to MOF and the representation of SBVR model content using MOF are 
described below, divided using the following headings.
23.3.1 MOF Packages for SBVR Vocabulary Namespaces
MOF Elements of the SBVR XMI Metamodel
The SBVR Vocabulary  is mapped to the SBVR XMI Metamodel, which is made up of one package, which is a MOF-based 
reflection of the SBVR vocabulary namespace.
Elements of SBVR Content Models
The package that makes up the SBVR XMI Me tamodel contain classe s and associations. 
Rationale
The SBVR XMI Metamodel package can be imported or merg ed into other MOF-based me tamodels. For example, a 
metamodel of organizational structure can import the SBVR  XMI Metamodel package as a starting point for modeling 
organization types and organizational roles. Similarly, a metamodel of business pro cess can import the SBVR XMI 
Metamodel package in order to relate pr ocesses to rules, or for modeling semantic formulations of rules that govern 
processes. Heading Purpose
MOF Elements of the SBVR XMI Metamodel Prescriptive description of the mapping of the SBVR Vocabulary into a 
MOF-based metamodel
Elements of SBVR Content Models Prescriptive description of how fact s are represented within an SBVR 
Content model
Rationale Design rationale explaining aspects of SBVR or MOF that led to the MOF 
representations described here
196                 Semantics of Business Vocabulary and Business Rules, v1.323.3.2 MOF Classes for SBVR Noun Concepts
MOF Elements of the SBVR XMI Metamodel
Each designation in a vocabulary namesp ace for a noun concept that is not a role is mirrored in the SBVR XMI 
Metamodel as a class. The sign ifier of the designation is the name of the class. The signifier of each synonym of the 
designation is an alias for the class. 
The metamodel includes generalizations between classes reflecting generaliza tions between the represented noun 
concepts. Each SBVR  concept besides ‘ thing ’ specializes ‘ thing ’, so the classes have the class ‘ thing ’ as a superclass 
either directly or indirectly.  
The classes in the metamodel that mirror the follo wing concepts are abstract (isAbstract = true):
actuality
binary logical operation
bindable target
closed semantic formulation
community
concept
expression
fact
logical formulation
logical operation
meaning
modal formulation
projecting formulation
quantification
res
semantic formulation
set
situation
state of affairs
thing
Example V ocabulary:                 characteristic
General Concept: verb concept
Synonym:          unary verb concept
Semantics of Business Vocabula ry and Business Rules, v1.3        197Figure:
SBVR XMI Metamodel:
Elements of SBVR Content Models
Where a class represents a noun concept, an element (in an SBVR Content model) that instantiates the class represents a 
fact that an instance of the noun concept exists.  Referen ces to the element within the SBVR Content model indicate 
references to the instance of the noun concept.  Note that it is possible that two elements in an SBVR Content model 
represent the same actual thing (23.3.1 e xplains situations where this is likely an d tells how to relate the two elements 
within the SBVR Content model).  Also, a lack of an elem ent in an SBVR Content model implies nothing - it does not 
imply that something does not exist.
An element of an abstract class exists in a MOF-based model only by instantiating a nonabstract subclass of that abstract 
class.
Rationale
Use of aliasing, though not common in MOF-based metamodels , keeps a strong alignment of the SBVR XMI Metamodel 
with the SBVR vocabulary.
The SBVR XMI metamodel is intended to provide for representin g meanings and their representa tions.  It is not intended 
for representing things in general.  Ma king some classes abstract simplifies interpretation of  SBVR Content models by 
limiting them to SBVR’s scope.
Some UML figures in Clauses 8 through 12 show partitioning or disjoint categories using UML notation, but those 
features are not included in MOF 2.0, so partitioning and disj ointness are not reflected in the SBVR XMI Metamodel.  
Also, MOF 2.0 does not support association cl asses.  Each case of an association class in a figure corresponds with a verb 
concept and a noun concept, and each of the two is represented separa tely in the SBVR XMI Metamodel.
23.3.3 MOF Boolean Attribut es for SBVR Characteristics
MOF Elements of the SBVR XMI Metamodel
A characteristic is represented in MOF as an optional Boolean attribute as shown below.
Example V ocabulary:
variable  is unitarycharacteristic
unary verb concept also:verb concept
characteristic
{element import characteristic asunary verb concept}verb concept
198                 Semantics of Business Vocabulary and Business Rules, v1.3Figure:
SBVR XMI Metamodel:
Elements of SBVR Content Models
For an element in an SBVR Content model, the meaning of the value TRUE  is that the characteristic is attributed to the 
thing represented by the element.  A meaning of FALSE  is that the thing represented by the element does not have the 
characteristic.  A meaning of the attribute being null is the same as the attribute being unspecified for the element.  
Rationale
The attribute is optional in support of the Open  World Assumption, explained in 23.4.2 below.
23.3.4 MOF Associations for SBVR Binary Verb Concepts
MOF Elements of the SBVR XMI Metamodel
Each binary verb concept is represen ted in MOF terms as an association.  Association names match verb concept 
wordings.  If a verb concept has only one verb concept wordi ng, the association's name is the expression of that verb 
concept wording, but with subscripts raised to normal text .  The names of the association's ends are the placeholder 
expressions from the verb concept wording. The ends are ow ned by the association so that individual links can be 
serialized using XMI.
In cases of more than one verb concept wording (synonymous form s), one is chosen to name the association that does not 
imply a designation in an attributive name space.  Then there is an alias for the association for each other verb concept 
wording that has matching placehol der expressions (which implies ma tching association end names).
In figures in the normative clauses, a label on an as sociation line that includes a reading direction arrow (“ ”)              
is meant to be read starting with the name of the class on th e first end and ending with the name of the class on the other 
end, except where a name for an end is already in the label.   The association names match this reading exactly.  Including 
the names of an  association's ends in the association’s na me makes the association's name  unique within a package, as 
required by MOF.
In cases where an association’s ends both connect to the same  class, subscripts are used on placeholders to distinguish 
them.  In the association name and its e nds’ names the subscripts are raised to no rmal text and serve to distinguish the 
ends.  
Example V ocabulary:
 concept1 specializes  concept2
Synonymous Form:   concept2 generalizes  concept1variable
is uni tary
is unitary : Core::PrimitiveTypes::Boolean [0..1]variable
Semantics of Business Vocabula ry and Business Rules, v1.3        199Figure:
SBVR XMI Metamodel:
Some structural rules impose multiplicity constraints for binary  verb concepts. These are shown in the Figures in Clauses 
8 through 12 and are included in the SBVR XMI Metamodel.
Elements of SBVR Content Models
Where an association represents a binary verb concept, a link of the association within an SBVR Content model 
represents a fact of that binary verb concept. The absence of a link implies nothing. There are no defaults. 
Rationale
Partitive verb concepts are shown in fi gures as UML shared aggregation, whic h is not supported by MOF 2.0.  All 
association ends in the SBVR XMI metamodel are noncomposite.
23.3.5 MOF Attributes for SB VR Roles of Verb Concepts
MOF Elements of the SBVR XMI Metamodel
A role of a binary verb concept that has a designation in an  attributive namespace is unde rstood in MOF terms as an 
attribute owned by the subject class.  Such  designations appear in figures as na mes on association ends.  In the example 
below, ‘element’ is in an attributive na mespace for the concept ‘set,’ so it is mi rrored in the SBVR XMI Metamodel as an 
attribute.
Example V ocabulary:
thing  is in set
Synonymous Form: set includes  thing
Synonymous Form: set has element
Figure: sp eci ali zes
conceptgeneralizes
concept1 specializes concept2
conc eptconcept1
concept2
{element import  concept1 specializes concept2 as concept2 generalizes concept1 }
thing setelementincludes
is in
200                 Semantics of Business Vocabulary and Business Rules, v1.3SBVR XMI Metamodel:
In each case where an attribute and an association end represent the same role, the SBVR XMI Metamodel includes a tag 
that tags both the attribute and the association end. The tag connects them to show their correlation. The tag’s name is 
“org.omg.sbvr.sameRole ,” its value is "" (the empty string), and its el ements are the attribute and the association end.
Where structural rules impose multiplicity constraints, they  are shown in figures and are included in the SBVR XMI 
Metamodel for association ends and for attributes.
Elements of SBVR Content Models
Where a role of a binary verb concept is understood in MOF te rms as an attribute, specification of the attribute for an 
element in an SBVR Content model represents the entire extension of that verb concept for the element. There are no 
defaults. If the attribute is unspecified for an element, it is simply unspecified; it is not presumed by default to have no 
value.  If anything is specified, all values of the attribute ar e specified.  Specification that the attribute is null means th ere 
is no instance of the verb concept for the element.
Rationale
The attributes described in the sub clause are in addition to the associations that represent the binary verb concepts - the 
reason for the distinction is explained below.  
To preserve ‘set’ semantics, any two va lues of the same attribute of the same element in an SBVR Content Model 
represent two different things.  Where an attribute has two or  more values, it can be conclu ded that each of the values 
represents a thing that is distinct from the others.
23.3.6 MOF Classes for SBVR  Ternary Verb Concepts
MOF Elements of the SBVR XMI Metamodel
MOF 2.0 does not support ternary associations . Therefore, a ternary verb concept is  represented in MOF terms as a class 
with one single-valued, required attribute fo r each role of the verb concept. The class’s name takes the same form as the 
name of an association for a binary verb concept. If there are multiple verb concept wordings for a ternary verb concept, 
aliases are used.
Example V ocabulary:
state of affairs  involves  thing  in role
Figure:element : thing [*]setthing is in setthing
{element import  thing is in set as set includes thing }
state of affairs role
state of affairs involves thing in rolething
Semantics of Business Vocabula ry and Business Rules, v1.3        201SBVR XMI Metamodel:
Elements of SBVR Content Models
In an SBVR Content model, an element of such a class represents a fact of the ternary verb concept.
23.3.7 Data Values
MOF Elements of the SBVR XMI MetamodelThe classes ‘ text’ and ‘ integer ,’ representing ‘ text
’ and ‘ integer ,’ have data attributes shown below.
SBVR XMI Metamodel:
Elements of SBVR Content Models
If one of these attributes is specified in an SBVR Content mode l, the represented text or inte ger is the specified value.  
Specification of null is equivalent to not specifying anything. There are no defaults.
The concepts ‘ text’, ‘integer ’, and ‘ number ’ are SBVR noun concepts, so their instances can be represented like 
instances of other noun concepts (see 23.2. 2 MOF classes for SBVR Noun Concepts) without using the ‘value’ attributes 
shown above. A specific number can be identified by a designation. The ISO 6093 Number Namespace  includes 
designations of all integers and of numbers with decimal places. Each designation in the ISO 6093 Number Namespace  
shall be interpreted according to [ISO 6093].
Each text value is a Unicode string and is  considered without regard to markup.
Rationale
The attributes are optional because SBVR allows that texts and integers, like othe r kinds of things, can be described by 
facts without necessarily being identified.  Also, the data types ‘ String ’ and ‘ Integer ’ in MOF have size limitations, so 
the attributes cannot be used for all case s.  To refer to a string or integer that  is beyond the MOF limitations, a model can 
identify the string or integer using facts about it that satisfy  a reference scheme.  For example, the number 999999999999 
can be identified as having a designation in the ISO 6093 Number Namespace  with the signifier “999999999999”.state of affairs : state of affairs [1]
thing : thing [1]role : role [1]state of affairs involves thing in role
value : Core::Primiti veTypes::Integer [0..1]integer
value : Core::PrimitiveTypes::String [0..1]text
202                 Semantics of Business Vocabulary and Business Rules, v1.323.3.8 XMI Names
MOF Elements of the SBVR XMI Metamodel
A named element is tagged with an ‘ org.omg.xmi.xmiName ’ tag if its XMI name differs from its MOF name. XMI 
names are determined from MOF names by upcasing each charact er that follows a blank and then removing the blank. 
The names, which come from the SBVR voc abularies, do not contain any characters  that are invalid in XML identifiers.
23.4 Using MOF to Represent Semantics
The SBVR XMI Metamodel is a direct reflection of the SBVR  vocabulary, which represents SBVR meanings, but this 
direct representation of SBVR meanings requires two seman tic modeling capabilities not directly provided by MOF 2.0.  
The two following clauses explain how th e two capabilities, multiclassification and the Open World Assumption, are 
supported by the SBVR XMI Metamodel.
23.4.1 Multiclassification
MOF 2.0 requires that each element is described by one class (its “metaClass”).  Sometimes a thing cannot be represented 
by an element of a single class. This happens when a thing is an instance of multiple concepts, neither one specializing 
the other.  To represent this case , multiple elements are used, one per concept. A link of the association ‘ thing1 is 
thing2 ’ (representing the verb concept ‘ thing1 is thing2’) is used to indicate that the multiple elements represent the 
same thing. A consumer of a model in which two elements repr esent the same thing should assume that a fact represented 
in reference to either element applies to both elem ents (since they both represent the same thing).
As an example, consider the noun concepts ‘ closed logical formulation ’ and ‘ obligation formulation .’  Neither 
specializes the other.  Where an obligation formulation is a cl osed formulation that formulates a proposition, a model uses 
one element of type ‘ closed logical formulation ’ and a separate element of type ‘ obligation formulation ’ along 
with a ‘ thing1 is thing2 ’ link that says the two elements represent the same thing.
23.4.2 Open World Assumption
The open world assumption is that representation of facts in a model does not imply that those are the only facts of a 
particular type nor that they are the only facts of a particular type about a subject thing - there are no implications to be 
taken from what is not represented in a mode l.  For example, consider facts about a se t S.  The two facts, “1 is in S” and 
“2 is in S,” do not convey the same meaning as “S = {1, 2} ” because the two facts do not imply anything about whether 
other things are in S.
In general, models represent facts with an open world assumption.  But some refe rence schemes use roles of binary verb 
concepts extensionally, so models represent a complete ex tension with respect to a subject thing being identified.
MOF supports the open world assumption about instantiation of classifiers (classes and associations). MOF’s attributes 
support representation of an entire extension of an attribute w ith respect to a given subject.  In order to enable a clear 
distinction in a model between individual facts and complete ex tensions with respect to a subject, association links are 
used to represent individual facts of a bi nary verb concept while attr ibutes are used when identifying a complete extension 
of a binary verb concept with respect to a particular subject.   This means that a fact can in one model be represented by 
a link, and in another by a value of an attribute of an elemen t.  The fact is represented using an attribute only when the 
complete extension of the verb concept is being represented for the subject.  Examples of both cases appear in the 
Semantics of Business Vocabula ry and Business Rules, v1.3        203example below.  SBVR has a designation in an attributive na mespace for every role that is extensionally used by a 
reference scheme such that the SBVR XMI Metamodel has the required attributes  to satisfy all of SBVR’s reference 
schemes.  
23.5 Example SBVR Content Model
Consider the following example, which includes a sm all portion of a vocabulary and a rule statement.
companyofficercompany
 appoints officer
EU-Rent
     General Concept:  companyEU-Rent must appoint at least 3 officers.
The following figure is a UML instance diagram showing an SBVR Content model of the example. Some end names are 
elided where they are obvious from the class names or for ‘ thing1 is thing2 ’ (where it makes no difference). For 
elements of the vocabulary, the three laye rs of expression, representation, and me aning are apparent in the diagram. The 
rule, shown at the bottom, connects to the meanings of the elements of the vocabulary though its logical formulation.
204                 Semantics of Business Vocabulary and Business Rules, v1.3The example SBVRContent model is expressed belo w in XML based on the SBVR XML Schema. The xmi:id  values are 
arbitrary and have no special meaning, but they build on the related signifiers to help re adability.  The XML tags, which 
include the namespace prefix ‘ sbvr’, are the XMI names for model elem ents of the SBVR XMI Metamodel.
<?xml version="1.0" encoding="UTF-8" ?>
<xmi:XMI xmi:version="2.1" xmlns:xm i="http://schema.omg.org/spec/XMI/2.1"  
xmlns:sbvr="http://www.omg.o rg/spec/SBVR/20070901/SBVR.xml">
For ‘company’:
<sbvr:designation xmi:id="company" si gnifier="company-t" meaning="company-c"/>
<sbvr:generalConcept xm i:id="company-c"/>
<sbvr:text xmi:id="com pany-t" value="company"/>

Semantics of Business Vocabula ry and Business Rules, v1.3        205For ‘officer’:
<sbvr:designation xmi:id="of ficer" signifier=" officer-t" meaning="officer-c"/>
<sbvr:generalConcept xm i:id="officer-c"/>
<sbvr:text xmi:id="officer-t" value="officer"/>
For ‘company  appoints officer ’:
<sbvr:sententialForm xmi:id="companyA ppointsOfficer" expression="cao-t" meani ng="cao-c" placeholder="cao-p1 cao-p2"/>
<sbvr:binaryVerbConcept xmi:id="c ao-c" role="cao-r1 cao-r2"/>
<sbvr:verbConceptWordingIncorporatesVe rbSymbol verbConceptWording="companyA ppointsOfficer" verbSymbol="appoints"/>
<sbvr:designation xmi:id ="appoints" signifier="appoi nts-t" meaning="cao-c"/>
<sbvr:text xmi:id="cao-t" va lue="company appoints officer"/>
<sbvr:text xmi:id="appoints-t" value="appoints"/>
<sbvr:placeholder xmi:id="cao-p1" ex pression="company-t" startingCharacte rPosition="i1" meaning="cao-r1"/>
<sbvr:placeholderUsesDesignation plac eholder="cao-p1" desi gnation="company"/>
<sbvr:roleRangesOverObjectType role=" cao-r1" generalConc ept="company-c"/>
<sbvr:verbConceptRole xmi:id="cao-r1"/><sbvr:positiveInteger xmi:id="i1" value="1"/>
<sbvr:placeholder xmi:id="cao-p2" ex pression="officer-t" startingCharacte rPosition="i18" meaning="cao-r2"/>
<sbvr:placeholderUsesDesignation placehol der="cao-p2" designat ion="officer"/>
<sbvr:roleRangesOverObjectType role=" cao-r2" generalConcept="officer-c"/>
<sbvr:verbConceptRole xmi:id="cao-r2"/><sbvr:positiveInteger xmi: id="i18" value="18"/>
For ‘EU-Rent
’ with “General Concept: company”:
<sbvr:designation xmi:id=" EU-Rent" signifier="EU-Rent -t" meaning="EU-Rent-c"/>
<sbvr:individualConcept xmi:id="EU-Rent-c"/><sbvr:text xmi:id="EU-Rent-t" value="EU-Rent"/><sbvr:concept1SpecializesConcept2 concept 1="EU-Rent-c" concept2="company-c"/>
For “EU-Rent must appoint at least 3 officers”:
<sbvr:statement xmi:id="stmt" expr ession="stmt-t" meaning="stmt-p"/>
<sbvr:text xmi:id="stmt-t" value="EU-R ent must appoint at least 3 officers"./>
<sbvr:proposition xmi:id="stmt-p"/><sbvr:closedLogicalFormulationFormalizesStatement  closedLogicalFormulation=" ob2" statement="stmt"/>
<sbvr:closedLogicalFormulationMeans Proposition closedLogicalFormulati on="ob2" proposition="stmt-p"/>
<sbvr:obligationFormulation xmi:id="ob"/><sbvr:closedLogicalForm ulation xmi:id="ob2"/>
<sbvr:thing1IsThing2 thi ng1="ob" thing2="ob2"/>
<sbvr:modalFormulationEmbedsLogica lFormulation modalFormulation=" ob" logicalFormulation="am3"/>
<sbvr:at-least-nQuantification xmi:id="am3" scopeFormulation="a tom" minimumCardinality="i3"/>
<sbvr:quantificationIntroducesVariable quantification="am3" variable="v"/>
<sbvr:variable xmi:id="v" ranged-over Concept="officer-c" restrictingFor mulation="" isUn itary="false"/>
<sbvr:atomicFormulation xmi:id ="atom" roleBinding="bind1 bind2"/>
<sbvr:atomicFormulationIsBasedO nverbConcept atomicFormulation= "atom" verbConcept="cao-c"/>
<sbvr:roleBinding xmi:id="bind1"/><sbvr:roleBindingBindsToBindableTarget roleBi nding="bind1" bindableTarget="EU-Rent-c"/>
206                 Semantics of Business Vocabulary and Business Rules, v1.3<sbvr:verbConceptRoleHasRoleBinding verb ConceptRole="cao-r1" roleBinding="bind1"/>
<sbvr:roleBinding xmi:id="bind2"/><sbvr:roleBindingBindsToBindableTarget roleBinding="bind2" bindableTarget="v"/>
<sbvr:verbConceptRoleHasRoleBinding verb ConceptRole="cao-r2" roleBinding="bind2"/>
<sbvr:positiveInteger xmi:id="i3" value="3"/>
</xmi:XMI>
The example shows some of the points explai ned previously about SBVR Content models.
• Fact Model - the entire XM L content represents a fact model , which is a combination of a conceptual schema  and a 
set of facts.  The conceptual schema of the fact  model is identified in the heading where it says, xmlns:sbvr=”http://
www.omg.org/spec/SBVR/20070901/SBVR.xml. ”  The URL identifies a document that  serializes the SB VR Content Model 
for SBVR, which describes the concepts and rules that make  up the conceptual schema (see 23.4 and 25.4).  The 
elements of the XML cont ent represent the set of facts of the fact model.
• Multiclassification - There is an occurrence of ‘ thing1IsThing2 ’ which is used to connect a pa ir of elements that represent 
the same thing.  There is an element of type ‘ obligationFormulation ’ (xmi:id="ob" ) and another element of type 
‘closedLogicalFormulation ’ (xmi:id="ob2" ).  Neither type specializes the other so  there is one element of each type and a 
‘thing1IsThing2 ’ link indicates that the two elem ents represent the same thing.
• Open World Assumption - Links, rather than  attributes, are always used where ther e is an open world assumption, such 
as for the fact that the individual no un concept ‘EU-Rent’ specializes the con cept ‘company’ - there is no indication 
that these concepts are not invo lved in other specializations.
• Attributes giving Complete Extensions for a Subject - E ach specification of an attrib ute occurs where the entire 
extension of the attribute is be ing specified for a subject thing, such as fo r identifying the two placeholders of the verb 
concept wording ‘company  appoints officer ’ or the two roles of the verb concept.  The one ‘variable’ in the example is 
serialized with “ restrictingFormulation=”” ” representing that it has no restrictin g formulation.  In a number of cases, 
attributes are unspecified because the entire extension of the attr ibute for an element is not being specified.  For 
example, the attribute ‘ representation ’ is unspecified for the elements  representing meanings (e.g., ‘ company-c ’ and 
‘officer-c ’ - there can be any number of repres entations of a meaning, and the example model does not specify them all.  
However, each representation has exactly one meaning, so the ‘ meaning ’ attribute is specified fo r each representation to 
identify its one meaning.
23.6 The SBVR Content Model for SBVR
The SBVR Content Model for SBVR repres ents facts concerning all of the formally captioned contents of Clauses 7 
through 12.  In general, this includes all of the information given in the SBVR specification about its concepts that can be 
represented in terms of the SBVR  XMI Metamodel. This includes: 
• noun concepts and their designations
• verb concepts and thei r verb concept wordings
• specializations /generalizations
• concept types• definitions and, where formal, their semantic formulations
• necessity statements and, where formal, their semantic formulations
• vocabularies, language, namespaces and their URIs• notes, examples, sources, descriptions
Semantics of Business Vocabula ry and Business Rules, v1.3        207The SBVR Content Model for SBVR is like the example in sub clause 23.3 above except that it is about SBVR’s 
vocabulary and meanings, not EU-Rent’s. The complete SBVR Content Model for SBVR is serialized as XML documents 
listed in 25.4. It can be used and extended by other SB VR Content models that build on SBVR’s concepts.
23.7 XMI for the SBVR Model of SBVR
XML patterns are shown below for the various  parts of vocabulary descriptions and vocabulary entries used in Clauses 7 
through 12. These patterns are used to cr eate the XML documents that seriali ze the SBVR Content Model for SBVR.  
Each pattern is shown for a corresponding SBVR Structur ed English entry (see Annex A for entry descriptions).
The XML patterns provide a normative definition of which SB VR concepts are represented by each use of SBVR 
Structured English in the vocabulary descriptions  and entries contained in Clauses 7 through 21.
The general principles used for the patterns are these:  First, the facts of what is  presented using SBVR Structured English 
are represented using XML. Second, for the objects referenced  by those facts, further facts are represented to satisfy 
reference schemes for those objects wherever sufficient deta il is given. The principles are applicable to SBVR-based 
communication in general.  The XML files identified in sub clause 23.3, which are created based on these principles 
following the patterns below, are examples of  XML serializations of SBVR Content models.
The xmi:id  values used in the patterns below are replaced by different values in the actual XML documents because the 
multitude of repetitions of the patterns need their own unique xmi:id  values.  But the xmi:id  values shown below 
consistently and correctly show relati onships within the patterns.  Most xmi:id  values are referenced only locally within 
the XML elements for the same Structured English entry, but some are referenced beyond that scope and are shown in 
bold blue (e.g., "vocabulary ") so that references to them are easily follo wed.  The different types of vocabulary entries 
(term, name and verb concept wording) are mu tually exclusive.  They each introduce an xmi:id  value "meaning " which is 
referenced in other patterns.
Made-up names (e.g., “ Xyz Vocabulary ”), terms (e.g., “ example term ”) and verb concept wordings (e.g., “ example  is 
seen ”) are used to show the patterns and to show how signi fiers and other expressions appear in XML.  Certain 
assumptions are made by the patterns based on the way the voc abularies in Clauses 7 through 12 are interrelated.  The 
patterns assume that a vocabulary being described has a name in the Vocabulary Registration Vocabulary  (of Clause 7).  The 
patterns assume that where a term or name is used with a formal interpretation in Structured English, that term or name 
is found by way of the vocabulary namespace derived from th e vocabulary being described.  These assumptions are 
correct regarding Clauses 7 through 12, but they cannot ne cessarily be assumed about all vocabulary descriptions.
Each pattern has a part that remains unchanged for the kind of entry or caption shown (except for differences in xmi:id  
values as described above) and a part that  varies based on the content of the entry.   The part that varies is shown in bold 
italics .  It can be a text or integer value , a quoted xmi:id  of an object introduced elsewhere, or an XML tag.
The final XML documents created from the vocabulary clauses can differ slightly from what is exactly produced from the 
templates, but the represented meaning does not differ.  In cases where two objects are created and then connected by a 
‘thing1IsThing2 ’ link, the objects can be combined into one if they are of the same class or if one class specializes the 
other.  In cases where the patterns would create two identical XML elements, only one is actually created.  For example, all uses of an element for the integer 1 can use the same element.
23.7.1 XML Patterns for Vocabularies
Xyz Vocabulary
<sbvr:vocabulary xmi:id=" vocabulary "/>
<sbvr:nameReferencesThing thing="v ocabulary" name="XyzVocabulary"/>
208                 Semantics of Business Vocabulary and Business Rules, v1.3<sbvr:name xmi:id="XyzVocabulary" signifi er="v-s" meaning="v ocabulary-concept"/>
<sbvr:individualConcept xmi:id=" vocabulary-concept " instance="vocabulary"/>
<sbvr:text xmi:id="v-s" value=" Xyz Vocabulary "/>
<sbvr:designationIsInNamespace designation="XyzVocabul ary" namespace="vocabul aryRegistrationNamespace"/>
<sbvr:vocabularyNamespace xmi:id=" vocabularyNamespace "/>
<sbvr:vocabularyNamespaceIsDerivedFro mVocabulary vocabularyNamespace="vocabular yNamespace" vocabulary="vocabulary"/>
The pattern above assumes the Vocabulary Registration Vocabulary  has a vocabulary namespace like this:
<sbvr:vocabularyNamespace xmi:id=" vocabularyRegistrationNamespace "/>
Included V ocabulary: Abc Vocabulary
<sbvr:vocabulary1IncorporatesVocabulary2  vocabulary1="vocabul ary" vocabulary2=" Abc"/>
<sbvr:namespace1IncorporatesNamespace2 nam espace1="vocabularyNam espace" namespace2=" Abc-ns "/>
      The pattern above assumes there is a vocabulary named Abc Vocabulary  like this:
<sbvr:vocabulary xmi:id="Abc"/>
<sbvr:vocabularyNames pace xmi:id="Abc-ns"/>
Language: English
<sbvr:language xmi:id="language"/>
<sbvr:vocabularyNamespaceIsForLanguage vocabular yNamespace="vocabularyN amespace" language="language"/>
<sbvr:nameReferencesThing th ing="language" name="English"/>
<sbvr:name xmi:id="English" si gnifier="l-s" meaning="l-c"/>
<sbvr:individualConcept xmi: id="l-c" instance="language"/>
<sbvr:text xmi:id="l-s" value=" English "/>
<sbvr:designationIsInNamespace designati on="English" namespace="ISO639-2English"/>
<sbvr:vocabularyNamespace xmi:id="ISO639-2English"/>
<sbvr:namespaceHasURI namespace= "ISO639-2English" URI="lm-u"/>
<sbvr:URI xmi:id="lm-u"  
value="http://www.loc.gov/standar ds/iso639-2/php/English_list.php"/>
Namespace URI: http://some.uri
<sbvr:namespaceHasURI namespace="voc abularyNamespace" URI="vn-uri"/>
<sbvr:URI xmi:id="vn-uri" value=" http://some.uri "/>
Speech Community: English Mechanics
<sbvr:speechCommunityOwnsVocabulary speec hCommunity="em" voc abulary="vocabulary"/>
<sbvr:conceptHasInstance concept=" em-concept " instance="em"/>
<sbvr:speechCommunity xmi:id="em"/>
      It is assumed for this entry that there is a name ‘ English Mechanics ’ for an individual noun concept like this:
<sbvr:name xmi:id="em-name" signif ier="em-s" meaning="em-concept"/>
<sbvr:individualConcept xmi:id="em-concept"/>
<sbvr:text xmi:id="em-s" value="English Mechanics"/>
The captions “Description:”, “Note:” and “Source:” are handled  for a vocabulary in the same way as for terms within a 
vocabulary, as shown below, except th at the related meaning is given as meaning="vocabulary-concept".
Semantics of Business Vocabula ry and Business Rules, v1.3        20923.7.2 XML Patterns for General Concepts
example term
<sbvr:term xmi:id="exampleTerm"  signifier="et-s " meaning="meaning"/>
<sbvr:generalConcept xmi:id=" meaning "/>
<sbvr:text xmi:id="et-s" value=" example term "/>
<sbvr:thingIsInSet set="vocabulary" thing="exampleTerm"/><sbvr:designationIsInNamespace designation="exampleTerm" name space="vocabularyNamespace"/>
      If there is no “See:” caption, then the following is included:
<sbvr:preferredDesi gnation xmi:id="exam pleTermPreferred"/>
<sbvr:thing1IsThing2 thing1="exampleTerm Preferred" thing2="exampleTerm"/>
Concept Type: role
<sbvr: role xmi:id="meaningAsRole"/>
<sbvr:thing1IsThing2 thing1="m eaningAsRole" thing2="meaning"/>
     The pattern above is used if the concept type is an SB VR concept.  The pattern below is used if the concept type is  
     not an SBVR concept.
Concept Type: example type
<sbvr:conceptHasInstance concept=" exampleType-c " instance="meaning"/>
      There is assumed to be a term ‘ example type ’ for a general concept like this:
<sbvr:term xmi:id="exampleType" signifier ="exampleType-s" meaning="exampleType-c"/>
<sbvr:generalConcept xmi: id="exampleType-c"/>
<sbvr:text xmi:id="exampleTy pe-s" value="example type"/>
Definition: example  that is seen
<sbvr:definition xmi:id="def-formal" ex pression="def-formal- e" meaning="meaning"/>
<sbvr:text xmi:id="def-formal-e" value=" example that is seen "/>
<sbvr:concept1SpecializesConcept 2 concept1="meaning" concept2=" example-concept " />
<sbvr:closedProjectionFormalizes Definition closedProjection=" def-formal-projection " definition="def-formal"/>
<sbvr:closedProjectionDefines NounConcept closedProjection=" def-formal-projection " nounConcept="meaning"/>
      The closed projection of the definition (not shown) has xmi:id="def-formal-projection" . It is assumed for this entry  
      and several others that there is a term ‘ example ’ for a general concept like this:
<sbvr:term xmi:id="example" signifier ="example-s" meaning="example-concept"/>
<sbvr:generalConcept xmi:id=" example-concept "/>
<sbvr:text xmi:id=" example-s " value="example"/>
Definition: example  that shows something
<sbvr:definition xmi:id="def-semiformal" ex pression="def-semiforma l-e" meaning="meaning"/>
<sbvr:text xmi:id="def-s emiformal-e" value=" example that shows something "/>
<sbvr:concept1SpecializesConcept 2 concept1="meaning" concept2=" example-concept " />
Definition: whatever demonstrates
<sbvr:definition xmi:id="def-i nformal" expression="def-inf ormal-e" meaning="meaning"/>
<sbvr:text xmi:id="def-informal-e" value=" whatever demonstrates "/>
Description: A description of something
<sbvr:descriptionPortraysMeaning de scription="desc" meaning="meaning"/>
210                 Semantics of Business Vocabulary and Business Rules, v1.3<sbvr:description xmi:id="des c" expression="desc-e"/>
<sbvr:text xmi:id ="desc-e" value=" A description of something "./>
Dictionary Basis: example  
None
Example: An example of an example
<sbvr:descriptiveExampleIllustratesMeaning descriptiveExample=" de" meaning="meaning"/>
<sbvr:descriptiveExample xmi: id="de" expression="de-e"/>
<sbvr:text xmi:id="de-e" value=" An example of an example "/>
General Concept: example  
<sbvr:concept1SpecializesConcept 2 concept1="meaning" concept2=" example-concept " />
Necessity: Each  example  is seen . 
<sbvr:statement xmi:id="nec-stmt" expression="nec-e" meaning="nec"/>
<sbvr:text xmi:id="nec-e" value=" Each example is seen "./>
<sbvr:proposition xmi:id="nec" isNecessarilyTrue="true"/>
<sbvr:closedLogicalFormulationFormalize sStatement closedLogicalFormulation=" nec-formulation " statement="nec-stmt"/>
<sbvr:closedLogicalFormulationMeansPr oposition closedLogica lFormulation=" nec-formulation " proposition="nec"/>
      A closed logical formulation of the statement (not shown) has xmi:id="nec-formulation" .
Note: This note says little.
<sbvr:noteCommentsOnMeaning not e="note" meaning="meaning"/>
<sbvr:note xmi:id="note"  expression="note-e"/>
<sbvr:text xmi:id="note-e" value=" This note says little "./>
Possibility: Some  example  is seen . 
<sbvr:statement xmi:id="pos-stmt" expression="pos-e" meaning="pos"/>
<sbvr:text xmi:id="pos-e" value=" Some example is seen "./>
<sbvr:proposition xmi:id="pos " isPossiblyTrue ="true"/>
<sbvr:closedLogicalFormulationFormalize sStatement closedLogicalFormulation=" pos-formulation " statement="pos-stmt"/>
<sbvr:closedLogicalFormulationMeansPr oposition closedLogica lFormulation=" pos-formulation " proposition="pos"/>
      A closed logical formulation of the statement (not shown) has xmi:id="pos-formulation" .
Reference Scheme: An id of the example term  and the  set of authors  of the example term  
<sbvr:referenceScheme xmi:id=" refScheme" simplyUsedRole=" ethi-r2 " extensionallyUsedRole=" etha-r2 "  
identifyingCharacteristic=""/>
      It is assumed for this entry that there is a binary verb concept ‘ example term  has id’ whose ‘ id’ role has  
      xmi:id="ethi-r2" .
      It is assumed for this entry that there is a binary verb concept ‘ example term  has author ’ whose ‘ author ’ role has  
      xmi:id="etha-r2" .
See: example general concept designation  
Same as “Synonym: example general c oncept designation ”.
Source: ISO 1087-1 [‘example’]
<sbvr:referenceSupportsMeaning re ference="ref" meaning="meaning"/>
<sbvr:reference xmi:id="re f" expression="source-e"/>  
<sbvr:text xmi:id="source-e" value=" ISO 1087-1 [‘example’] "/>
Semantics of Business Vocabula ry and Business Rules, v1.3        211Subject Field: Philosophy  
<sbvr:representationIsInSubjectF ield representation="exampleTe rm" subjectField="philosophy"/>
<sbvr:conceptHasInstance concept=" philo-concept " instance="philosophy"/>
<sbvr:subjectField xmi:id="philosophy"/>
      It is assumed for this entry that there is a name ‘ Philosophy ’ for an individual noun concept like this:
<sbvr:name xmi:id="philo- name" signifier="philo-s" meaning="philo-concept"/>
<sbvr:individualConcept xm i:id=" philo-concept"/>
<sbvr:text xmi:id="philo-s" value="Philosophy"/>
Synonym: example general concept designation
<sbvr:term xmi:id="exampleO bjectTypeDesignation" signifi er="eotd-s" meaning="meaning"/>
<sbvr:text xmi:id="eotd-s" value=" example general concept designation "/>
<sbvr:thingIsInSet set="vocabulary" thing="exampleObjectTypeDesignation"/>
<sbvr:designationIsInNamespace desi gnation="exampleObjectTypeDesignati on" namespace="vocabularyNamespace"/>
23.7.3 XML Patterns for Individual Noun Concepts
Example Name
<sbvr:name xmi:id="exam pleName" signifier="en- s" meaning="meaning"/>
<sbvr:individualConcept xmi:id=" meaning "/>
<sbvr:text xmi:id="en-s" value=" Example Name "/>
<sbvr:thingIsInSet set="vocabulary" thing="exampleName"/><sbvr:designationIsInNamespace designation="exampleName" nam espace="vocabularyNamespace"/>
      If there is no “See:” caption, then the following is included:
<sbvr:preferredDesi gnation xmi:id= "exampleNamePreferred"/>
<sbvr:thing1IsThing2 thing1="exampleName Preferred" thing2="exampleName"/>
Definition: the example  that is seen
<sbvr:definiteDescription xmi:id="defDesc-formal" expression="defDesc-for mal-e" meaning="meaning"/>
<sbvr:text xmi:id="defDesc-formal-e" value=" the example that is seen "/>
<sbvr:concept1SpecializesConcept2 concept1= "meaning" concept2="example-concept" />
<sbvr:closedProjectionFormalizes Definition closedProjection=" defDesc-formal-projection " definition="defDesc-formal"/>
<sbvr:closedProjectionDefines NounConcept closedProjection=" defDesc-formal-projection " nounConcept="meaning"/>
      The closed projection of the definition (not shown) has xmi:id="defDesc-formal-projection" .  Note that informal and  
      semiformal definitions of individual noun concepts follow the same pattern as show n for general concepts above  
      with the exception that they are rendered as sbvr:definiteDescription .
The captions “Concept Type:”, “Descrip tion:”, “Dictionary Basis:”, “Example :”, “General Concept:”, “Necessity:”, 
“Note:”, “Possibility:”, “See:”, “Source:”,  “Subject Field:” and “Synonym:” are ha ndled for a name in the same way as 
for terms as shown above .
23.7.4 XML Patterns for Verb Concepts
example  is seen
<sbvr:sententialForm xmi:id="exam pleIsSeen" expression="eis-e" meani ng="meaning" placeholder="eis-p"/>
<sbvr:verbSymbol xmi:id="example.isSeen"  signifier="isSeen-s"  meaning="meaning"/>
<sbvr:characteristic xmi:id=" meaning " role="eis-r"/>
212                 Semantics of Business Vocabulary and Business Rules, v1.3<sbvr:verbConceptWordingIncorporatesVe rbSymbol verbConceptWording="example IsSeen" verbSymbol="example.isSeen"/>
<sbvr:text xmi:id ="eis-e" value=" example is seen "/>
<sbvr:text xmi:id="isSeen-s" value=" is seen "/>
<sbvr:placeholder xmi:id ="eis-p" expression=" example-s " startingCharacterPositio n="i1" meaning="eis-r"/>
<sbvr:placeholderUsesDesignation placeholder="eis-p"  designation=" example "/>
<sbvr:positiveInteger xmi:id="i1" value=" 1"/>
<sbvr:verbConceptRole xmi:id=" eis-r "/>
<sbvr:roleRangesOverObjectType  role="eis-r" generalConcept=" example-concept "/>
<sbvr:thingIsInSet set="voca bulary" thing="exampleIsSeen"/>
<sbvr:thingIsInSet set="voca bulary" thing="example.isSeen"/>
<sbvr:verbConceptWordingIsInNamespa ce verbConceptWording="exampleIsS een" namespace="vocabularyNamespace"/>
<sbvr:attributiveNamespaceIsW ithinVocabularyNamespace attri butiveNamespace="example-ans"  
vocabularyNamespace="v ocabularyNamespace"/>
<sbvr:attributiveNamespac e xmi:id="example-ans"/>  
<sbvr:attributiveNamespaceI sForSubjectConcept attribut iveNamespace="example-ans"  
subjectConcept=" example-concept "/>
<sbvr:designationIsInNamespace designation="e xample.isSeen" namespace="example-ans"/>
example1 follows example2
<sbvr:sententialForm xmi:id=" example1FollowsExample2" ex pression="efe-e" meaning="meani ng" placeholder="efe-p1 efe-p2"/>
<sbvr:verbSymbol xmi:id="efe-follows"  signifier="follows- s" meaning="meaning"/>
<sbvr:binaryVerbConcept xmi:id=" meaning " role="efe-r1 efe-r2"/>
<sbvr:verbConceptWordingIncorporatesVerbSy mbol verbConceptWording="example1Follo wsExample2" verbSym bol="efe-follows"/>
<sbvr:text xmi:id="efe-e" value=" example1 follows example2 "/>
<sbvr:text xmi:id=" follows-s" value=" follows "/>
<sbvr:text xmi:id=" example1-s " value=" example1 "/>
<sbvr:text xmi:id="example2-s" value=" example2 "/>
<sbvr:placeholder xmi:id="efe-p1" ex pression="example1-s" startingCharact erPosition="i1" meaning="efe-r1"/>
<sbvr:placeholder xmi:id="efe-p2" ex pression="example2-s" startingCharact erPosition="i18" meaning="efe-r2"/>
<sbvr:placeholderUsesDesignation placeholder="efe-p1" designation=" example "/>
<sbvr:placeholderUsesDesignation placeholder="efe-p2" designation=" example "/>
<sbvr:positiveInteger xmi:id="i1" value=" 1"/>
<sbvr:positiveInteger xm i:id="i18" value=" 18"/>
<sbvr:verbConceptRole xmi:id=" efe-r1 "/>
<sbvr:verbConceptRole xmi:id=" efe-r2 "/>
<sbvr:roleRangesOverObjectType  role="efe-r1" generalConcept=" example-concept "/>
<sbvr:roleRangesOverObjectType  role="efe-r2" generalConcept=" example-concept "/>
<sbvr:thingIsInSet set="vocabulary"  thing=" example1FollowsExample2"/>
<sbvr:thingIsInSet set="voca bulary" thing=" efe-follows"/>
<sbvr:verbConceptWordingIsInNamespace verb ConceptWording="example1FollowsExample2" 
namespace="vocabularyNamespace"/>
Definition: the example1 comes after  the example2 in a sequence
<sbvr:definition xmi:id="efe-def-formal" ex pression="efe-def-forma l-e" meaning="meaning"/>
<sbvr:text xmi:id="efe-def-formal-e" value=" the example1 comes after the example2 in a sequence "/>
<sbvr:closedProjectionFormalizes Definition closedProjection=" efe-projection " definition="efe-def-formal"/>
<sbvr:closedProjectionDefinesve rbConcept closedProjection=" efe-projection " verbConcept="meaning"/>
<sbvr:variableMapsToVerbConceptRole variable=" efe-var1 " verbConceptRole=" efe-r1 "/>
<sbvr:variableMapsToVerbConceptRole variable=" efe-var2 " verbConceptRole=" efe-r2 "/>
The definition formally defines ‘ example1 follows example2’ and has a closed projection (not shown) with  
xmi:id="efe-projection" projectionVariable="efe-var1 efe-var2" .
Semantics of Business Vocabula ry and Business Rules, v1.3        213Definition: the first example is after the second
<sbvr:definition xmi:id="efe-def-informal" expr ession="efe-def-informa l-e" meaning="meaning"/>
<sbvr:text xmi:id="efe- def-informal-e" value=" the first example is after the second "/>
See: example1 has prior example  
Same as “Synonymous Form: example1 has prior example ”.
Issue # 15684: Revise text
Synonymous Form: example1 has prior example  
<sbvr:sententialForm xmi:id="example1HasPriorExample " expression="ehpe-e" meani ng="meaning" placeholder="ehpe-p1  
ehpe-p2"/>
<sbvr:verbSymbol xmi:id="ehpe-has" signifier="has-s" meaning="meaning"/>
<sbvr:verbConceptWordingIncorporatesVerb Symbol verbConceptWording="example1H asPriorExample" verbSymbol="ehpe-has"/>
<sbvr:verbConceptRoleDesignation xmi: id="example.priorExample" signifier ="priorExample-s" meaning="efe-r2"/>
<sbvr:text xmi:id="ehpe-e" value=" example1 has prior example "/>
<sbvr:text xmi:id="has-s" value=" has"/>
<sbvr:text xmi:id="priorExample-s" value=" prior example "/>
<sbvr:placeholder xmi:id ="ehpe-p1" expression=" example1-s " startingCharacterPositio n="i1" meaning="efe-r1"/>
<sbvr:placeholder xmi:id="ehpe-p2" expres sion="priorExample-s" st artingCharacterPosition= "i14" meaning="efe-r2"/>
<sbvr:placeholderUsesDesignation placeholder="ehpe-p1" designation=" example "/>
<sbvr:positiveInteger xmi:id="i1" value=" 1"/>
<sbvr:positiveInteger xmi:id="i14" value=" 14"/>
<sbvr:thingIsInSet set="vocabulary" thing="example1HasPriorExample"/>
<sbvr:verbConceptWordingIsInNamespace verb ConceptWording="example1HasPriorExample" 
namespace="vocabularyNamespace"/>
<sbvr:attributiveNamespaceIsW ithinVocabularyNamespace attri butiveNamespace="example-ans"  
vocabularyNamespace= "vocabularyNamespace"/>
<sbvr:attributiveNamespac e xmi:id="example-ans"/>  
<sbvr:attributiveNamespaceI sForSubjectConcept attribut iveNamespace="example-ans"  
subjectConcept=" example-concept "/>
<sbvr:designationIsInNamespace des ignation="example.priorExampl e" namespace="example-ans"/>
      If there is a term ‘ prior example ’ for a general concept like this:
<sbvr:term xmi:id="priorExample" signifier= "priorExample-s" meani ng="priorExample-c"/>
      then the following is included:
<sbvr:placeholderUsesDesignation placeholder="ehpe-p2" designation=" priorExample "/>
<sbvr:roleRangesOverObjectType role="efe-r2" generalConcept=" priorExample-c "/>
The captions “Concept Type:”, “Descrip tion:”, “Dictionary Basis:”, “Example :”, “General Concept:”, “Necessity:”, 
“Note:”, “Possibility:” and “Source:” ar e handled for a verb concept wording in the same way as for terms as shown 
above .
Issue # 10630:  Revise text
23.7.5 XML Patterns for Sets of El ements of Guidance (Rule Sets)
Xyz Rules
<sbvr:set xmi:id=" ruleSet "/>
<sbvr:nameReferencesThing thi ng="ruleSet" name="XyzRules"/>
<sbvr:name xmi:id="XyzRules " signifier="XyzRules-s" meaning="ruleSet-concept"/>
214                 Semantics of Business Vocabulary and Business Rules, v1.3<sbvr:individualConcept xmi:id=" ruleSet-concept " instance="ruleSet"/>
<sbvr:text xmi:id="XyzRules-s" value=" Xyz Rules "/>
<sbvr:thingIsInSet set="voc abulary" thing="XyzRules"/>
<sbvr:designationIsInNamespace designation=" XyzRules " namespace= "vocabularyNamespace"/>
V ocabulary: Abc Vocabulary
None.
The captions “Description:”, “Note:”, a nd “Source:” are handled for a rule set in the same way as for terms within a 
vocabulary, as shown above, except th at the related meaning is given as meaning="ruleSet-concept".
23.7.6 XML Patterns for Guidance Statements
Each  example  must  be seen . 
<sbvr:guidanceStatement xmi:id="stmt-formal"  expression="stmt-form al-e" meaning="meaning"/>
<sbvr:elementOfGuidance xmi:id=" meaning "/>
<sbvr:text xmi:id="st mt-formal-e" value=" Each example must be seen "./>
<sbvr:closedLogicalFormulationFormalize sStatement closedLogicalFormulation=" stmt-formal-formulation "  
statement="stmt-formal"/>
<sbvr:closedLogicalFormulationM eansProposition closedLogicalFor mulation="stmt-formal-formu lation" proposition="meaning"/>
<sbvr:thingIsInSet set= "ruleSet" thing="meaning"/>
The closed logical formulation of the statement (not shown) has xmi:id="stmt-formal-formulation" .
Guidance Type: operative business rule  
      In this case where the guidance type is an SBVR concept, the line above that says,  
      “ <sbvr:elementOfGuidance xmi:id="meaning"/> ”, is replaced with this:
<sbvr: operativeBusinessRule  xmi:id="meaning"/>
Guidance Type: exemplary rule  
<sbvr:conceptHasInstance concept=" exemplaryRule-c " instance="meaning"/>
      This pattern is used if the concept type is not an SBVR concept.  There is assumed to be a term ‘ exemplary rule ’ for 
      a general concept like this:
<sbvr:term xmi:id="exemplaryR ule" signifier="exem plaryRule-s" meaning="exemplaryRule-c"/>
<sbvr:generalConcept xmi: id="exemplaryRule-c"/>
<sbvr:text xmi:id="exemplaryRul e-s" value="exemplary rule"/>
Enforcement Level: strict 
<sbvr:operativeBusinessRul eHasLevelOfEnforcement  
operativeBusinessRule="meaning"  
levelOfEnforcement="strict-instance"/>
<sbvr:conceptHasInstance concept=" strict-concept " instance="strict-instance"/>
<sbvr:levelOfEnforcement xmi:id="strict-instance"/>
      It is assumed that the name ‘ strict ’ represents an individual noun concept like this:
<sbvr:name xmi:id="strict" signifier=" strict-s" meaning="strict-concept"/>
<sbvr:individualConcept xm i:id="strict-concept"/>
<sbvr:text xmi:id="stri ct-s" value="strict"/>
Name: Rule 25  
Semantics of Business Vocabula ry and Business Rules, v1.3        215<sbvr:nameReferencesThing th ing="meaning" name="Rule25"/>
<sbvr:name xmi:id="Rul e25" signifier="Rule25-s"  meaning="rule25Meaning"/>
<sbvr:individualConcept xmi:id="ru le25Meaning" instance="meaning"/>
<sbvr:text xmi:id="Rule25-s" value=" Rule 25 "/>
<sbvr:thingIsInSet set="v ocabulary" thing="Rule25"/>
<sbvr:designationIsInNamespac e designation="Rule25" namesp ace="vocabularyNamespace"/>
Synonymous Statement: It is obligatory that each rule be seen .
<sbvr:guidanceStatement xmi:id="synstmt-formal" expression="synstmt-for mal-e" meaning="meaning"/>
<sbvr:text xmi:id="syns tmt-formal-e" value=" It is obligatory that each rule be seen "./>
<sbvr:closedLogicalFormulationFormalize sStatement closedLogicalFormulation=" synstmt-formal-formulation "  
statement="synstmt-formal"/>
<sbvr:closedLogicalFormulationMeansPr oposition closedLogicalFormulation=" synstmt-formal-formulation " proposition="meaning"/>
The closed logical formulation of the statement (not shown) has xmi:id="synstmt-formal-formulation" . 
The captions “Description:”, “Example:”, “Note:” and “Source:”  are handled for a guidance statement in the same way as 
for terms as shown above .
216                 Semantics of Business Vocabulary and Business Rules, v1.3
Semantics of Business Vocabula ry and Business Rules, v1.3  21 724 Providing Semantic and Logical Foundations for 
Business Vocabulary and Rules
24.1 General
This clause lists and explains fou ndational concep ts taken from respected works on formal lo gics and mathematics.  A 
mappin g is then shown from the concepts in the SBVR Vocabularies in Clauses 7 through 21 to these foundational concepts.
Sub clause 24.2 pro vides a formal semantics for the concepts in the SBVR Vocabu laries in Clauses 7 through 21. Clause 24.3 
provides the map ping of the concepts in the SBVR Vocab ularies in Clauses 7 thro ugh 21 to ISO Common Logic and to OWL/
ODM.
24.2 Logical Foundations for SBVR
24.2.1 SBVR Formal Groundi ng Model Interpretation
24.2.1.1 Introduction
A con ceptual model includes both a concep tual schema and a population of facts th at confo rm to the schema. A conceptu al 
model may cover any desired time span, and  contain facts concerni ng th e past, present, or futu re. Th is notion is distinct from 
changes made to a conceptual model. Any ch ange to a concep tual model, includin g any change to  any fact in the fact 
population , creates a different c onceptual model.  Each conceptual m odel is d istinct an d independent, althou gh th ere ma y be 
relationsh ips bet ween conceptual m odels that share the same conceptual schema.
‘Facts’ are one  of the primary building blocks o f the formal in terpretation o f SBVR p resented h ere. A ‘Ground Fact’ is of a 
particular ‘Fact Type .’ The lowest level logical unit in SBVR – an ‘Atomic Formulatio n’ – is a logical formulation based 
directly upon  a verb  concept, in volving  no logi cal op eration. An atomic formulation may be considered as an invocation of a 
predicate.
The formal interpretatio n of SBVR presented here makes no dis tinction abou t how facts are know n: for example, wheth er they 
are asserted as 'ground facts' or obtained by inference. Inferen ces can be p erformed within a particular fact mod el. The formal  
interpretation of SBVR presented here does not defin e any kind of inference that can  be made between fact models.
Control over the order in which inferences can b e made is a common feat ure in the automation of inf erence, as found, for 
example, in rules en gines. SBVR deals with declarative rules expressed from a business pe rspective. Transitio ns between fact  
models and th e mechan ization of tho se rules in an auto mated system are outside the scope o f SBVR.
Closed-world assumptions are often used in automated systems, su ch as th e well-k nown ‘negatio n by fail ure’ in the Prolog 
language. Th e bus iness orientation of SBVR ma kes it natural to assume open-world semant ics by defau lt. For exampl e, if we 
assume that ‘Customers’ have some unary fact such as ‘C redit OK’ then we cannot assume anything like ‘Credit not OK’ in 
the ab sence of this fact. The formal interp retation of SB VR presented here permit s fact types to be explicitly identified as 
closed wh ere this makes business sense. Fo r example, it may be approp riate to infer ‘Credit not OK ’ for a subset of customers 
identified as ‘Credit-Checked Cu stomers’ in the absence of a ‘Credit OK’ fact.
The detailed definition  of SBVR uses the vocabulary defin ed in SBVR –  in ot her words, SBVR is defined in term s of itself. 
This inevitably makes the SBVR vocabularie s higher order, bu t this does not force any mode ler to pro duce exclusiv ely higher-
order models. Th e formal interpretation of SBV R presented here can be used to produce first order interpretations for SBVR 
vocabulair es if that is wh at is desired by t he modeler.
218                 Semantics of Business Vocabulary and Business Rules, v1.3The SBVR (Semantics of Business V ocabul ary and Business Rules) vocabularies are used to describe business vocabularies 
and business rules that may be expressed eith er informally or formally. Business rule expressions are classi fied as formal only  
if they are expressed purely in terms of n oun concepts and verb concepts, as well as certain logical/ ma thematical operators, 
quantifiers, etc. The following discussion of business rule sema ntics is confined to formal st atements of business rules. (A 
closer definition of terms is given as needed later throughout this clause.)
The rest of this clause is structured as follows: sub clause 24.2.1.2 provides some basic background and terminology, 
explaining our usage of terms such as “s chema,’ “model,” and “fact.” 24.2.1.3 re views the approach to choosing open or 
closed world semantics. 24.2.1.4 provides an overview of the us e of quantifiers as well as alet hic or deontic modal operators i n 
specifying business rules. 24.2.1.5 and 24.2.1.6 respectively di scuss the formal semantics for static, alethic constraints and 
static, deontic constraints. 24.2 .1.7 considers derivation rules. 24.2.1.8 exam ines dynamic constraints. 24.2.1.9 reviews the 
option for using higher-order logic.
24.2.1.2 Facts, Schemas, and Models
For any given business, the “universe of discourse” indicates t hose aspects of the business th at are of interest. The term 
“business domain” is commonly used in the modeling community, with equivalent meaning. A “model,” in the sense used 
here, is a structure intended to describe a bu siness domain, and is comp osed of a conceptual schema  (fact structure) and a 
population  of ground facts (see later). A fact is a proposition taken to be true by the business. Population facts are restricted to 
elementary and existential facts (see later).
Instantiated roles of facts refer to indi viduals (such as “Employee 123” or “the sales department”). These individuals are 
considered as being of a part icular type (such as “Emplo yee” or “Department”) where type denotes “set of possible 
individuals.”  
SBVR’s ‘general concept’, ‘indivi dual noun concept’ and ‘verb co ncept’ are three kinds of conc ept (unit of knowledge created 
by a unique combination of characteristics [per ISO-1087-1]). Each is a kind of m eaning – respectively, the meaning of an 
improper noun phrase, the meaning of a proper noun and the meaning of a verb phrase in the contex t of a declarative sentence. 
Instances of verb concepts are actualities th at involve things that exist in the unive rse of discourse. These instances are not  
propositions. In contrast, the logical underpinnings of these thr ee kinds of concepts are ‘type of individual’, singleton ‘type  of 
individual’, and ‘fact type’, respectively.
• General concepts logically map to types of individual. Each type of individual is a set of possible instances of the 
general concept according to a set of po ssible existential facts that can be formulated based on reference schemes.
• Individual noun concepts logically map to singleton types of individuals. Each single type of individual has exactly one 
element, which is the instance of the individual noun concept.
Verb concepts map to fact types, each fact type being a set of possible ground facts that can be  formulated based on the verb 
concept and that use reference schemes to identif y, for each fact, each thi ng that fills each role.
The conceptual schema declares the concepts, fact types  (kinds of facts, such as “Emp loyee works for Department”) and rules  
relevant to the business domain. 
The terms ‘rule’ and ‘business rule,’ in th e senses used here, are defined in 24.2.2 . Rules are effectivel y higher-level facts (i.e., 
facts about propositions), and in a loose sense are also someti mes considered under the generic term ‘fact.’ For clarity, the t erm 
“ground fact” is used here to expl icitly exclude such (meta) facts. 
Semantics of Business Vocabula ry and Business Rules, v1.3        219Constraints  are used to define bounds, borders, or limits on  fact populations, and may be static or dynamic. A static constraint  
imposes a restriction on what fact p opulations are possible or pe rmitted, for each fact popu lation taken individually. 
A dynamic constraint  imposes a restriction on transitions between fact populations.  
Derivation rules  indicate how the population of a fact type may be derive d from the populations of on e or more fact types or 
how a type of individual may be defined in terms of other types of individuals and fact types.
A model of the kind considered here is a fact model , not a process model. The term knowledge base  is sometimes used to 
reflect this focus (on what is known, as op posed to what must be done). At least two kinds of fact model may be specified: 
reality models; and in-practice models. Although both these models  use the same set of fact types, they may differ in the 
constraints imposed on those fact types. A reality model  of a business domain is intended to reflect the constrai nts that actually 
apply to the business domain in the real world. An in-practice model  of a business domain reflect s the constraints that the 
business chooses in practice to impose on its knowledge of the business domain.
Constraint differences between reality and in-practice models have some restricti ons (for instance, in-practice uniqueness 
constraints need to be at least as strong as the corresponding r eal world uniqueness constraints,  and if a fact type role is 
optional in the real world it is optional in the in -practice world, but the converse need not apply).
Reality schemas are sometimes constructed first to help dete rmine in-practice schemas. Although a population may be added 
to any schema to form a model, it is common to add populations  only to in-practice schemas. So in-practice models are more 
common than reality models. The possibility of incomplete know ledge arises for both reality and in-practice models but is Static constraint
Each  Employee was born on at most one  Date 
Dynamic constraint
A person’s marital status may change from single to married, but not from divorced to single 
Derivation rules
Person1 is an uncle of Person2 if Person1 is a brother of some  Person3 who is a parent of Person2, 
Each  Australian is a Person who is a citizen of Country ‘AU.’
Suppose the following two fact types are of interest: Em ployee was born on Date; Employee has PhoneNumber. 
In the real world, each employee is born, and may hav e more than one phone number. Hence the reality model 
includes the constraint “ Each  Employee was born on at least one  Date” and allows that “ It is possible that the 
same  Employee has more than one  PhoneNumber.” Now suppose that the business decides to make it 
optional whether it knows an employee’ s birth date. Suppose also that the business is interested in knowing at 
most one phone number for any given employee. In th is case, the in-practice model excludes the reality 
constraint “ Each  Employee was born on at least one  Date,” but it includes the following constraint that doesn’t 
apply in the reality model: Each  Employee has at most one  PhoneNumber.
220                 Semantics of Business Vocabulary and Business Rules, v1.3more prevalent with in-practice models si nce these tend to include more optional aspects. Adoption of open or closed world 
assumptions is discussed in 24.2.1.3. 
We use the term “fact model” or “knowledge base” in a broad se nse. Conceptually, the fact mode l is represented by a set of 
sentences, each of which connotes  either a rule or a ground fact. The fact model may be fully automated (as in, say, a database  
system), manual (as in, say, a paper record system), or semi-a utomated. The knowledge may even be stored in human memory 
(belonging to the business domain  experts who may be collectively regarded as th e authoritative source of those business facts 
that are of interest). However, the kno wledge must ultimately be expressible by sentences co mmunicated between humans. 
A fact model is a conceptual model of the business domain, usin g a suitable high level vocabular y and language that is readily 
understood by the business domain experts. Typically this language will be a formal subset of a natural language. In particular , 
the language is not a machine-orie nted technical language (such as C# or Java) that might be used to implement a system to 
enforce at least some of the business rule s included in the model. Business domain models are meant to capture the relevant 
business rules, not to implement them. Whether a given business rule is implemented at all, or how it might be implemented 
(automated, semi-automated, or manual) ar e not issues here. Typically however, it  is expected that many business rules 
specified in a business domain model will likely be enforced in an au tomated way; and in such cases, the rules need to be 
formally expressed.
Any fact model passes through a sequence of states , each of which includes a set of ground facts , which are either elementary 
or existential. Roughly speaking, an elementary fact  is a declaration that an individual has a property, or that one or more 
individuals participate in a relationship, where the fact cannot be split into simpler facts with the same individuals (without  
information loss).   
An elementary fact may be treated  as an instantiation of  a typed, irreducible pr edicate of interest to the business, except tha t 
multiple fact type readings using different predicates, possibl y based on different orderings of the individuals,  are considere d 
to express the same fact if they mean the same. Indi viduals are typically denoted by definite descriptions. 
Instead of definite descriptions, proper names may be used if  they function as individual constants in the business domain. 
Lexical individuals denote themselves.  Individual constants may al so be introduced as abbreviations of definite descriptions.Example of incomplete knowledge
The business might know just some of  a given employee’s phone numbers
Examples of elementary facts
The Country named ‘Aus tralia’ is large 
The President named ‘Bill Clinton’ was born in th e State named ‘Arkansas’
The sentences (1) and (2) bel ow express the same fact:
(1)  The President named ‘Bill Clinto n’ was born in the State that has the State Name ‘Arkansas.’
(2)  The State that has t he State Name ‘Arkansas’ is the birthpla ce of the Presedent named ‘Bill Clinton.’
“The President named ‘Bill Clinton’” is treated here as shorth and for “The President who has the President 
Name ‘Bill Clinton’” .
Example of a self-denoting lexical individual
The country code ‘US’ 
Semantics of Business Vocabula ry and Business Rules, v1.3        221We use the term “fact” in the sense of “p roposition taken to be true by the business”  (i.e., the business members are prepared 
to act as if they believed the proposition is true; their attitu de toward the proposition is one of epistemic commitment). This  
sense of epistemic commitment does not requ ire any special interpretation of logical op erators, or use of epistemic or doxastic  
logic. The logical connectives (and, or, no t, if-then, etc.) may be interpreted just  like truth functional operators (conjuncti on, 
disjunction, negation, material implication, etc.) in 2-valued classical logic. An existential fact  is used to simply assert the 
existence of an individual,
A fact type  may be identified by one or more fact t ype readings that decl are typed predicates.
Sub clause 24.2.1 uses initial capitals to denote types of indivi duals (other styles may be used for this purpose), and in gene ral 
allows predicates in mixfix notation.
More conventional but less readable  syntaxes may also be used.
Each predicate has a fixed arity, so variadic predicates  are not supported.Example of an existential fact
There is a Country that has the Country Code ‘US’
Examples of fact type readings
The President named 'Mary McAleese' governs the Country that has the Country Name 'Ireland'
is an instance of the fact type
President governs Country  
The Country that has the Country Name 'Ireland' is  governed by the President named 'Mary McAleese'
is an instance of the fact type
Country is governed by President
Example of mixfix notation
President visited Country on Date
Example of more conventional notation
President governs Country
may be expressed as
governs( x:President; y:Country)
For example, the unary "smokes" predicate in 'Person sm okes' is considered to be different from the binary 
"smokes" predicate in 'Per son smokes Cigar Brand.'
222                 Semantics of Business Vocabulary and Business Rules, v1.3Note that we do not identify untyped predicates simply by their name and arity.
The fact model includes both th e conceptual schema and the ground fact populatio n (set of fact instances  that instantiate the 
fact types in the schema). The concep tual schema includes a generic componen t and a domain-speci fic component. The 
generic component is common to all c onceptual schemas: this includes relevant axioms from logic and mathematics1. The 
domain-specific component includes the concept definitions an d declarations of the ground fact types and business rules 
relevant to the specific business domain. 
Trivially, each fact model includ es existential facts to declare the existence of generic constants such as numbers, but we 
ignore these in our discussion, confining the use of “population” to the domain-specific population of interest. With that 
understanding, the fact model at any point in time may be d eclared as a set of sentences that collectivel y express the 
conceptual schema and the fact p opulation of the domain-s pecific fact types in the conceptual schema. 
Although in practice the conceptual schema  may evolve over time (if the business domain changes its structure or scope of 
interest) we ignore schema evolution here, treating the conceptu al schema as fixed. Schema evolution may be handled as a 
metametalevel concern. Model exchange must be enabled between a system supporting SBVR and other systems identified as 
desirable targets for interoperabi lity. Any exchange of a fact m odel takes place at a given point in  time, and at that time the  
conceptual schema is fixed (lat er exchanges may be used to update the fact model as required). Also, when a necessity is 
originally stated, the intent is that by default the rule should stay in force. 
In contrast to the conceptual sche ma, the (domain-specific) fact population is typically highly variable.
Figure 24.1 provides a simplified picture of this situation, i ndicating that the fact model of sentences expressing population 
facts (instances of domain-specifi c fact types) is a varset (variable-set) whos e population at any given time is a set of facts . 
Figure 24.1 - Evolution of the fact model (schema plus ground fact instances)For example, the “has” in 'Person has Disease' is consi dered to be a different predicate from the "has" in 
'Disease has Cure.'
1. For a detailed discussion of one way to fo rmalize this, see [Halp1989]. A fact model is specified as a set of sentences in a language 
based on predicate logic with identity. An interpretation is defined in the usual way (e.g., each predicate symbol maps onto a relation 
over the domain of individuals) and a model ( not the same as fact model) is an interpretation where all the sentences are true.For example, the fact type "Employee works on Project" may initially have no instances, but over time thousands 
of employees may be added or removed from various project teams.
t0t1t2t3t4Nr
sentences
TimeConceptual schemaPopul ation facts
Semantics of Business Vocabula ry and Business Rules, v1.3        223The fact model may be initially empty or pre-populated with so me facts. The fact model may expand or shrink over time as 
facts are added or removed from it. At any point in time, the fact model includes a set of facts. Figure 24.2 depicts this 
situation in more detail, using a labeled box to denote a fact instance (f1 = fact 1, etc.).
Figure 24.2- Evolution of the ground fact population
In treating a fact model as a varset of facts that typically changes over time, we allow facts to be added or deleted  
(see Figure 24.2). We might delete a fact b ecause we revise our decision on whether it is (taken to be) tr ue (for instance, we 
might discover a mistake), or because we deci de that fact is no longer  of interest. Now consider the following description by 
[Anto2001] of non-monotonic logic.
The term “non-monotonic logic” covers a family of formal frameworks devised to capture and represent defeasible 
inference , i.e., that kind of infere nce of everyday life in which reasoners dr aw conclusions tentatively, reserving the 
right to retract them in  the light of further in formation. Such inferences are calle d “non-monotonic” because the set of 
conclusions warranted on the basis of a given knowledge base does not increase (in fact, it can shrink) with the size of 
the knowledge base itself. This is in contrast to classi cal (first-order) logi c, whose inferences, being deductively 
valid, can never be “undone” by new information.
On the surface, it would appear that we ar e committing to a non-m onotonic logic, given that we allow facts to be deleted in 
going from one state to another. However it seems reasonable to  formalize those business rules th at are static constraints in 
terms of classical, non-monotonic logic. 
In classifying the rule as a static constr aint, we assert that it is true for each st ate of the fact model, taken individually.  This 
seems to be enough, from the point of view of exchanging fact models, which always involves just one state at that time. Note 
also that the characterization of fact models as variable sets of sentences does  not claim that propositions change their truth  
value over time. We regard propositions to be atemporal: they are timelessly true or false, so never change their truth value. For example, we might formalize the st atic constraint that each person was born on some date as an SBVR 
logical formulation of the formula ∀x:Person ∃y:Date x was born on y.t0t1t2t3t4Population
Facts
f1f2f3
f1f2f3f4f6
f1f2f4f5
f1f2f3f4f5f7f8
Time
224                 Semantics of Business Vocabulary and Business Rules, v1.3At least superficially, it is possible that a sentence in one fact model state expre sses a different proposition from that expr essed 
by the same sentence in another fact mode l state. For example, the m eaning of time-deictic sent ence occurrences depends on 
the time they were uttered or inscribed.
24.2.1.3 Open/Closed World Semantics
Adopting closed world  semantics basically means that all relevant facts ar e known (either as primitives – not defined in terms 
of other things – or derivable). So if a proposition cannot  be proved true, it is assumed to be false. This closed world 
assumption  entails negation by failure , since failure to find a fact implies its negation. Open world semantics  allows that some 
knowledge may be incomplete; so if a proposition and its negatio n are both absent, it is unknown whether the proposition is 
true.
In modeling any given business domain, attention can be restricted to propositions  of interest  to that domain. If a proposition is 
not relevant to that domain, it is not includ ed as a fact there, but we do not assume it is false; rather we simply dismiss it from 
consideration. For any business domain, we have a finite set of types of individuals and fact types (typed predicates), and any 
type of individual or fact type outside this set is simply disregarded. 
It is a practical issue whether on e’s knowledge pertaining to the population of a given fact type is complete or not, since thi s 
may impact how the business derives other fact s (e.g., negations) or how it reacts to query results (e.g., whether to treat “no t” 
as “not the case” or merely “not  known to be the cas e”). So we regard the issue of open/cl osed world semantics to be relevant 
to the fact model itself, not just automated implementations of the fact model.
Many implementations treat “not” in the cl osed-world sense of either “not known” (as a primitive or derivable fact), i.e., 
negation as failure, or “not known as a primitive fact,” i.e ., semi-positive negation. For instance, Prolog-based rule engines 
rely on negation by failure, and the “not” in SQL means “n ot recorded in a base tabl e or derivable in a view.” For instance, given the static constraint that each person  lives in at most one countr y, we might assert for the 
fact model state 1 that Terry lives in Australia, for fact model state 2 we delete “Terry lives in Australia” and add 
that Terry lives in Utah, and for fact model state 3 we de lete “Terry lives in Utah” and add that Terry lives in 
Australia. This does not involve any change in proposit ion truth values, because different propositions were 
being asserted in the different states. Here the verb phrase  “lives in” means “currently lives in,” where ‘currently” 
may be unpacked into a time-indexed expression th at includes the time of that fact model state.
SQL example, 
Figure 24-3 depicts the relational schema and a sample  population for a database fragment used to store the 
employee number and name of each employee, as well as the cars they drive (if any).
Semantics of Business Vocabula ry and Business Rules, v1.3        225Figure 24.3 - A sample database storing some facts about employees
Knowledge about completeness is typically not stored in database s, although in principle it could be. Users typically adopt the  
closed world assumption when interpreting data in relational data bases. If independently of the database system they know 
how complete the data is, they may take that into account in deciding how complete ly the query results from the database 
system relate to the real world of their business domain.employee (empNr , empName) Employee Drives
empNr empName empNr carRegNr
Drives (empNr. carRegNr ) 1
23John Smith
Ann JonesJohn Smith1
23ABC123
AAA246DEF001
Suppose we want to know the employee number and nam e of each employee. In SQL we might formulate this 
query as select  * from  Employee, which returns the three rows of data  shown in the Employee table. This result 
returns the employee number and name of those employ ees referenced in the database. Whether this includes 
all the employees in the business domain depends on whether the database is complete with respect to the population of the elementary fact type Employee has Empl oyeeName. If it is complete , the fact type is closed, 
and we may treat the SQL query as equivalent to our intended query about the business domain. If it is not 
complete, then the fact type is open, and we may need to take into account that there may be more employees 
than listed in the result.
Suppose we want to know the employee number of eac h employee who does not drive a car for the database 
shown in Figure 24-3. In SQL we  might formulate this query as select  empNr from  Employee where  empNr 
not in  (select  empNr from  Drives). This returns just one employee nu mber (viz. 3). Whether this covers all the 
non-driver employees in the business domain depends on whether the population of the two fact types 
(Employee has EmployeeName and Employee drives Car) is complete or not. Again, this knowledge about completeness could be stored in the database, but typically  isn’t, in which case users need to rely on their own 
knowledge about completeness to decide whether the data returned is complete or not.
226                 Semantics of Business Vocabulary and Business Rules, v1.3The approach adopted here is fact-based (as opposed to attri bute-based), where each fact type  is modeled as a type of 
relationship, never as an attribute. Annex J provides extended examples of fact types expresse d in this way using a popular 
fact-based mode ling approach.
Example fact-based representation of a database schema
The information structure implied by the database schema shown in Figure 24-3 can be expressed as a set of 
fact types and constraints as follows, using the capi talized mixfix notational style described earlier:
Types of individuals
EmployeeCar
Employee Number
Employee NameCar Registration Number
(Note that here Employee and Car represent the kind of  real world individuals th at typically change state. 
Employee Number, Employee Name and Car Registration Number represent simple self-identifying lexical 
constants.)
Fact types
Employee has Employee Number
Employee has Employee NameCar has Car Registration Number
Employee drives Car
Semantics of Business Vocabula ry and Business Rules, v1.3        227To consider completeness claims, we can express additional requirements in terms of the fact model populations of types of 
individuals and the sequences of fact type roles they play in the population of fact types. A schema, as described earlier, is 
useful for clarifying the conditions under which completeness claims may be made.Constraints
Each Employee has exactly one Employee Number.
For each Employee Number, at most one Employee has that Employee Number.
Each Employee has exactly one Employee Name.Each Car has exactly one Car Registration Number.
For each Car Registration Number, at most one Car has that Car Registration Number.
It is possible that the same Employee driv es more than one Car and that more than one Employee drives               
       the same Car.
Completeness claims about a schema can be clarified by referring to whether fact type roles are mandatory and 
whether instances of fact type roles ar e unique. A fact type role is mandatory if, for each state of the fact model, 
each instance in the population of the associated type of in dividual must play that fact type role. A fact type role 
(or combination of fact type roles) is unique if, for each state of the fact model, each individual that instantiates 
the fact type role (or each sequence of individuals that instantiates the fact type role sequence) does so once 
only.
In the schema given above:
each Employee has exactly one Employee Name (mandat ory fact type role) but it is optional whether  
       an Employee drives a car.
each Employee has exactly one Employee Name: the Empl oyee fact type role is unique in this fact type  
       but the Employee Name fact type role is not (an Employee has only one Employee Name, but the same  
 Employee Name could refer to more than one Employee).
228                 Semantics of Business Vocabulary and Business Rules, v1.3For any given schema, the business might have complete knowledge about some parts and incomplete knowledge about other 
parts. So in practice, a mixture of open and closed  world assumptions may apply. We use the term “ local closure ” (or “relative 
closure”) for the application of the closed  world assumption to just some parts of the overall schema. One might assume open 
world semantics by default, and then apply local closure to speci fic parts as desired; or altern atively, assume closed world 
semantics by default and then apply “local openness.” We adopt the former approach as  it seems more realistic when modeling 
real business domains.
Closure (i.e., local closure) may be explic itly asserted for any type of individual, on a one-by-one basis, to declare that for  each 
state the fact model population agrees with that of the population of that type of individual in the actual business domain. Th e 
relevant meta-fact type is: “type of individual is closed.”  It  may be reasonable to assume closure for types of individual by 
default, but it seems unrealistic to  assume closure for predicates. 
Closure may also be asse rted for fact types. Semi-closure  is with respect to the fact model population of the types of individual 
playing a fact type role in the predicate. If closure has also b een declared for these types, th en (full) closur e also holds fo r the 
fact type (i.e., closure with respect to the domain population of  the types of individuals). The relevant meta-fact types are: 
“fact type is semi-closed” and “fact type is closed.” The meta-fact type “concep t is closed” applies to both types of individua ls 
and fact types, since both are concepts.
As seen earlier, closure for a fact  type is sometimes implied. A functional fact type role  is the complete argument of a 
uniqueness constraint. For schemas whose functional fact type roles are also functional in the business domain, the following 
implications hold. If a predicate includes a mand atory, functional fact type role, then  that predicate is semi-closed by 
implication (as in the employee na me example earlier). This result may be generali zed to the case of a mandatory fact type role  
that has a frequency constraint of exactly n (although some attribute-based approaches do not deal reliably with various n-ary 
cases). If a type of individual has a set of functional fact type roles that are disj unctively mandatory and mutually exclusive  (in Referring again to the Employee-Car sche ma, for any state of the fact model, let pop(I) denote the fact model 
population of the type of individual I in that state, and let pop(F) denote the fact model pop ulation of the fact type 
role sequence for the fact type F in that state. If the fact model is co mplete with regard to capturing the real 
world business domain, then for each state of the fact model the following three additional conditions are 
satisfied:
(1) pop(Employee)   = set of employees in the (real world) business domain (at that time)
(2) pop(Car)   = set of cars in the business domain 
(3) pop(Employee drives Car)= set of (employee, car) pairs from pop(Employee) × pop(Car) where that  
employee drives that car in the business domain.
Requirements (1) and (2) declare that the fact model popu lation of the Employee and Car types of individuals 
always matches that of the business domain being modeled . We may regard this as asserting the closed world 
assumption for those types of individuals. Requirement (3) asserts that for those employees and cars that are 
included in the fact model, if they drive a car then this fa ct is known. In combination, requirements (1) – (3) entail 
the closed world assumption for the drives fact type (if an employee drives a car in the business domain, this is 
known in the fact model). 
Given the schema, and requirement (1 ), the closed world assumption is implied for the employee name fact 
type. This follows because of the mandatory and uniquene ss constraints on the first fact type role (employee is 
closed, so we have all the employees; having a name is mandatory, so we have at least one name for each employee; the uniqueness constraint means that each employee has at most one name; so for all employees 
we now have all their names) . Note that open world sema ntics still applies to  the employee name  fact type; in 
the presence of (1) and the constraint s, this is equivalent to closed world semantics for that fact type.
Semantics of Business Vocabula ry and Business Rules, v1.3        229other words, they are spanned by an exclusive-or constraint), th en the predicates that include those fact type roles are semi-
closed by implication. If the type of individual has also been  declared complete in such cas es, then (full) closure applies.
For many fact types in a business domain, especially those withou t functional fact type roles, it is impractical to include all  the 
negative instances as primitive facts. 
In some cases however, especially with func tional fact type roles or when the population is small, it is practical to include 
negated facts as base facts. For example, for the fact type “Employee drives Car,” there might be many thousa nds of cars, so one would 
normally not explicitly include negated facts such as “Employee 1 does not drive Car ‘AAA246’.”
Example
To provide a concrete example of the alternative, we ca n consider the characteristic 'Person smokes,' and three 
instances of Person: Fred, Sue, and Tom (for simplicity we will ignore  reference schemes and assume that a 
person may be identified by their first name). 
Assume that we know that Fred smokes. If we use op en-world semantics, then it is unknown whether Sue or 
Tom smoke. If we apply closed world semantics, then the absence of facts that Sue or Tom smoke entails that 
they don't smoke.
If, for each Person, it is known whether that person smok es or not, then we could adopt one of two approaches 
to model our business domain.
(a) Use two characteristics, such as 'Person smokes' and 'Person is a nonsmoker,' with an exclusive-or 
constraint between the fact types. In other words, a Person  must play one fact type ro le or the other, but cannot 
play both.
(b) Use a binary fact type such as 'Person has Smoker Status' where Smoker Status is indicated by some 
suitable code such as 'S' or 'NS' (for smoker or n onsmoker respectively ), together with the constraint that a 
Person has exactly one Smoker Status.
In each of these cases, negated facts are explicitly treat ed as primitive facts and the predicates are given open 
world semantics. Semi-closure is implied because of the constraints.
Now consider a business domain where we know that Fred smokes, and that Sue doesn't smoke, but are 
unsure whether Tom smokes. In this case we have th ree alternative approaches that we could consider.
(a) Use two characteristics, such as 'Person smokes' and 'Person is a nonsmoker,' with an exclusion constraint 
between the fact types. In other words, a Person may play  one fact type role or the other (but not both) or may 
play neither fact type role. For the given scenario, we wo uld have the facts 'Fred smokes,' 'Sue is a nonsmoker' 
and no information for Tom.
230                 Semantics of Business Vocabulary and Business Rules, v1.3The above discussion indicates some ways of  declaring and inferring various kinds of closure in the underlying fact model, 
based on a default, open world semantics. Here, all business rule s that are parsed as formal are given a logical formulation 
based on the fact types in the underlying model. When people formulate queries on the model population, they may either adopt whatever closure guarantees are form ally captured in the model, or instead informally rely on their own knowledge 
about closure to decide whether the data returned is complete or not. Such informal knowledge is outside the fact model, and 
does not impact the formal semantics of the logi cal formulation used in exchanging fact models.
In addition to specifying fact models at a conceptual level, languages may be define d for querying these models directly at a 
conceptual level. These may include features  such as the ability to specify projections  in the scope of negation, as well as 
projections in the scope of the “whether-o r-not” operator which is used to perform conceptual left outer joins [Bloe1996. 
Bloe1997] . Further details are outs ide the scope of this sub clause.
24.2.1.4 Quantifiers and Modalities
Static constraints apply to each state of the fact model, taken indi vidually. These may typically  be expressed as logical 
formulations that are equivalent to formulae in 2-valued, firs t-order predicate calculus with id entity. The 2-valued restrictio n 
applies because the fact types on which th e rules are based are elementary (irreducib le), so their instances never involve null s. 
For convenience, we can use mixfix nota tion for predicates, and predefine some  numeric quantifiers in addition to ∀ and ∃. 
Table 24.1 summarizes th e pre-defined quantifiers. (b) Use a binary fact type such as 'Person has Smoker Status' where Smoker Status is indicated by some 
suitable code such as 'S' or 'NS' (for smoker or nonsmo ker respectively), together with the constraint that a 
Person has zero or one Smoker Status value. For the given scenario we would have the facts 'Fred has Smoker 
Status 'S,'' 'Sue has Smoker Status 'NS,'' and no information for Tom.
(c) Use a binary fact type such as 'Person has Smoker Status' where Smoker Status is indicated by some 
suitable code such as 'S,' 'NS,' or '?' (for smoker, no nsmoker, or unknown, res pectively), together with the 
constraint that a Person has exactly one Smoker Status. In this case we treat the 'unknown' value ('?') like any 
other value using 2-valued logic, rather than adopt a ge neric null based on 3-valued logic, as in SQL. For the 
given scenario we would have the facts “Fred has Smoker Status 'S,’” “Sue has Smoker Status 'NS,’'' and “Tom 
has Smoker Status '?’.''
Table 24.1- Quantifiers
Symbol Example Name Meaning
∀ ∀x Universal
QuantifierFor each and every x, taken one at a time
∃∃ x Existential Quan-
tifierAt least one x
∃1∃1xExactly-one 
quantifierThere is exactly one (at least one and at most one) x
∃0..1∃0..1xAt-most-one
quantifierThere is at most one x
Semantics of Business Vocabula ry and Business Rules, v1.3        231The additional existential quanti fiers are easily defined in terms of the standard quantifiers. 
The rule formulations covered here may use any of the basic alethic or deontic modal operators shown in Table 24.2. These 
modal operators are treated as proposition-forming operators on propositions (rather than actions). Other equivalent readings 
may be used in whatever concrete syntax is used to originally decl are the logical rule (e.g., “necessary” might be replaced by 
“required,” and “obligatory” might be repl aced by “ought to be the case”). Derived m odal operators may also be used in the 
surface syntax, but are translat ed into the basic modal operators plus negation (~). ∃0..n
(n ≥ 1)∃0..2x At-most- n
quantifierThere is at most n x
Note: n is always instantiated by a number ³ 1.
So this is really a set of quantifiers ( n = 1, etc.)
∃n..
(n ≥ 1)∃2..xAt-least- n
quantifierThere is at least n x
Note: n is always instantiated by a number ³ 1.
So this is really a set of quantifiers ( n = 1, etc.)
∃n
(n ≥ 1)∃2xExactly- n
quantifierThere is at exactly (a t least and at most) n x
Note: n is always instantiated by a number ³ 1.
So this is really a set of quantifiers ( n = 1, etc.)
∃n..m
(n ≥ 1, m ≥ 2)∃2..5xNumeric range
quantifierThere is at least n and at most m x
For example, the exactly-two quantifier ∃2 may be defined as follows. Let x, x1, x2 be individual variables and Φx 
be a well formed formula with no free occurrences of x1, x2. Then:
∃2x Φx  =df  ∃x1∃x2 [Φx1 & Φx2 & x1 ≠ x2 & ∀y(Φy ⊃ (y = x1 ∨ y = x2))]
Definition schemas for the other quantifiers may be found on page 4-11 of [Halp1989].
For example, “It is impossible that p” is defined as “It is not possible that p” (~p), and “It is forbidden that p” is 
defined as “It is not permitted that p” (Fp =df ~Pp).Table 24.1- Quantifiers
232                 Semantics of Business Vocabulary and Business Rules, v1.3Table Legend:Table 24.2 - Modalities
Modality Modal Formula applying modal negation rules ...
               = (Logically Equivalent) Modal Formula
Formula Reading (Verbalized 
as):Formula Reading (Verbalized as):
alethic necessity
□p It is necessary that  p ~~p It is not possible that not p
the negation of 
necessity:  
non-necessity~□p It is not necessary that   p   ~p It is possible that not p
possibility p It is possible that   p ~□~p It is not necessary that not  p
the negation of 
possibility:impossibility~
p It is not possible that  p
It is impossible that   p□~p It is necessary that not  p
contingency p  & ~□p It is possible but not necessary 
that  p~(~ p  v □p) It is neither impossible nor 
necessary that  p
deontic obligation Op It is obligatory that  p ~P~p It is not permitted that not  p
the negation of 
obligation:non-obligation~Op
It is not obligatory that  p P~p It is permitted that not  p
permission Pp It is permitted that  p ~O~p It is not obligatory that not  p
the negation of 
permission:prohibition~Pp
FpIt is not permitted that  p
It is prohibited that  p
It is forbidden that  pO~p It is obligatory that not p
optionality Pp & ~Op It is permitted  but not obligatory 
that  p~ ( ~Pp v Op) It is neither prohibited nor 
obligatory that  p
□ necessity = logically equivalent
 possibility & and
O obligation v or (inclusive-or)
P permission ~ not
F forbidden p some proposition
Semantics of Business Vocabula ry and Business Rules, v1.3        233The following modal negation rules  apply: it is not necessary that ≡ it is possible that not (~ □p ≡ ~p); it is not possible that ≡ 
it is necessary that not (~ p ≡ □~p); it is not obligatory that ≡ it is permitted that it is not the case that (~ Op ≡ P~p); it is not 
permitted that ≡ it is obligatory that it is not the case that (~ Pp ≡ O~p). In principle, these rule s could be used with double 
negation to get by with just one alethic and one deontic operator (e.g., p could be defined as ~ □~p, and Pp could be defined 
as ~O~p).
Every constraint has an associated modality,  determined by the logical modal operator that functions explicitly or implicitly a s 
its main operator. We can distinguish between positive, negati ve, and default verbalizations of constraints. In positive 
verbalizations, an alethic modality of necessity is often assume d (if no modality is explicitly specified), but may be explicit ly 
prepended. 
We interpret this in terms of possible world semantics , as introduced by Saul Kripke and other logicians in the 1950s. A 
proposition is necessarily tr ue if and only if it is true in all possible worlds. With respect to a static constraint  declared for a 
given business domain, a possible world corresponds to a state of the fact model  that might exist at some point in time. 
A proposition is possible if and only if it is true in at leas t one possible world. A proposition is impossible if and only if it is 
true in no possible world (i.e., it is false in all possible worlds). 
In practice, both positive and negative verbal izations are useful for validating constr aints with domain e xperts, especially 
when illustrated with sample populations that provide satisfy ing examples or counter-exampl es respectively. The approach 
described here does not stipulate a high level language for rule verbalization, so many alternativ e verbalizations may be used.  
Many business constraints are deontic rather  than alethic in nature. To avoid confus ion, we recommend th at, when declaring a 
deontic constraint, the deontic modality always be explicitly included.For example, the following static constraint
C1 Each  Person was born in at most one  Country.
may be explicitly verbalized with an alethic modality thus:
C1’ It is necessary that each  Person was born in at most one  Country.
The constraint C1 in the example abov e means that for each state of the fact model, each instance in the 
population of Person is born in at most one country.
In the example above, constraint C1 may be refo rmulated as the following negative verbalization: 
C1” It is impossible that the same  Person was born in more than one  Country.
234                 Semantics of Business Vocabulary and Business Rules, v1.3In practice, most st atements of business rules include only one modal operat or, and this operator is the main operator of the 
whole rule statement. For these cases, we simply tag the constr aint as being of the modality corresponding to its main operator , 
without committing to any particular modal logic. Apart from th is modality tag, there are some  basic modal properties that 
may be used in transforming the original high level expression of  the rule into a standard logical formulation. At a minimum, 
these include the modal negation rules. 
We also make use of equivalences that allow one to move the modal operator to  the front of the formula.
For such tasks, we assume that the Barcan formulae and their converses apply, so that □ and ∀ are commutative, as are  and 
∃.  In other words:  
∀x □ Fx ≡  □ ∀xFx
∃xFx    ≡ ∃xFxConsider the following static, deontic constraint.
C2 It is obligatory that each Person is a husband of at most one Person.
If this rule were instead expressed simply as “ each Person is a husband of at most one Person,” it would not be 
obvious that a deontic interpretation was intended . The deontic version indicates a condition that ought  to be 
satisfied, while recogniz ing that the condition might  not be satisfied. Including the obligation operator makes the 
rule much weaker than a necessity claim, since it allows that there could be some states of the fact model where a person is a husband of more than one wife (excludi ng same-sex unions from instances of the husband 
relationship). For such cases of polyg amy, it is important to know the facts indicating that the person has 
multiple wives. Rather than reject this possibility, we allow it an d then typically pe rform an action that is designed 
to minimize the chance of such a situation arising again (e.g., send a message to in form legal authorities about 
the situation).
Constraint C2 may be reformulated as either  of the following negative verbalizations: 
C2’ It is forbidden that the same  Person is a husband of more than one  Person.
C2” It is not permitted that the same  Person is a husband of more than one  Person.
For example, suppose the user formulates rule C1 instead as: 
For each  Person, it is necessary that that  Person was born in at most one  Country.
The modal operator is now embedded in the scope of a univ ersal quantifier. To transform this rule formulation to 
a standard logical formulation that classifies the rule as  an alethic necessity, we move the modal operator before 
the universal quantifier, to give:
It is necessary that each Person was born in at most one Country.
Semantics of Business Vocabula ry and Business Rules, v1.3        235While these commutativity results are valid for all normal, alethic modal logics, some philosophical concerns have been raised 
about these equivalences (e.g., see sub clauses 4.6-4.8 of [Girl2000])..
So far, our rule examples have included just one modal operator, which (perhaps after transformation) also turns out to be the 
main operator. Ignoring dynamic aspects, we may handle such cas es without needing to commit to the formal semantics of any 
specific modal logic. The only impact of tagging a rule as a necessity or obligat ion is on the rule enforcement policy. 
Enforcement of a necessity rule should neve r allow the necessity rule to be violated . Enforcement of an obligation rule should 
allow states that do not satisfy the obligat ion rule, and take some other remedial action: the precise action to be taken is no t 
specified in SBVR, as it is out of scope. At any rate, a business person ought to be able to specify a deontic rule first at a high 
level, without committing at that time to the precise action to be taken if the condition is not satisfied; of course, the acti on still 
needs to be specified later in refining the rule to make it fully operational.
24.2.1.5 Static, Al ethic Constraints
Rule formulations may make use of two alethic modal operators:  □ = it is necessary that;  = it is possible that. Static 
constraints are treated as  alethic necessities by default, where each state of the fact model corresponds  to a possible world..
For compliance with Common Logi c, formulae such as those in  the preceding example could th en be treated as irregular 
expressions, with the modal necessity operator treated as an  uninterpreted symbol (e.g., using “[N]” for □). However we leave 
this understanding as implicit, and do not commit to any particular modal logic. 
For the model theory, we omit the necessity  operator from the formula.  Instead, we merely tag the rule as a necessity. The 
implementation impact of the al ethic necessity tag is that any attempted change that would cause the model of the business 
domain to violate the constraint must be dealt with in a way th at ensures the constraint is still satisfied (e.g., reject the c hange, 
or take some compensatory action). 
Typically, the only modal operator in  an explicit rule formulation is □, and this is at the front of the rule formulation. This 
common case was covered earlier. If an alet hic modal operator is placed  elsewhere in the rule formulation, we first try to 
“normalize” it by moving the moda l operator to the front, us ing transformation rules such as the modal negation rules (~ □p ≡ 
~p; ~p ≡ □~p) and/or the Barcan form ulae and their converses ( ∀x□Φx ≡ □∀xΦx and ∃xΦx ≡ ∃xΦx, i.e., □ and ∀ are 
commutative, as are  and ∃).As a deontic example, suppose the user  formulates rule C2 instead as:  
For each  Person, it is obligatory that that Person is a husband of at most one  Person.
Using a deontic variant of the Barc an equivalences, we commute the ∀ and O operators, thus transforming the 
rule formulation into the deontic obligation:
It is obligatory that each Person is a husband of at most one Person.
Given the fact type Person was born  in Country, the constraint “ Each  Person was born in at most one  Country” 
may be captured by an SBVR logical formulatio n that may be automatically translated to the formula ∀x:Person 
∃0..1y:Country x was born in y. This formula is understood to be true for each state of the knowledgebase. 
Pragmatically, the rule is understood to apply to all future states of the fact model, until the rule is revoked or 
changed. This understanding could be made explicit by prepending the formula with □ to yield the modal 
formula □∀x:Person ∃0..1y:Country x was born in y.
236                 Semantics of Business Vocabulary and Business Rules, v1.3We also allow use of the following equivalences: □□p ≡ □p; p ≡ p; □□p ≡ □p; □□p ≡ □ p. These hold in S4, but 
not in some modal logics, e.g., K or T [Girl2000, p. 35].
To make life interesting, SBVR also allows a single rule fo rmulation to include multiple o ccurrences of modal operators, 
including the nesting of a modal operator within the scope of another modal operator. While this expressibility may be needed 
to capture some real business rules, it compli cates attempts to provide a formal semantics.
In extremely rare cases, a formula for a stat ic rule might contain an em bedded alethic modality that cannot be eliminated by 
transformation. For such cases, we could retain the modal operato r in the rule formulation and ad opt the formal semantics of a 
particular modal logic. There are many normal modal logics to  choose from (e.g., K, K4, KB, K5, DT, DB, D4, D5, T, Br, S4, 
S5) as well as many non-normal modal logics (e.g., C2, ED2, E2 , S0.5, S2, S3). For a discussi on of these logics, and their 
inter-relationships, see [Girl2000] (esp. pp. 48, 82). For SBVR, if we decide to retain the embedded alethic operator for such 
cases, we choose S4 for the formal semantic s. The possibility of schema evolution along with changes to necessity constraints 
may seem to violate S4, where the accessibi lity relationship between possible worlds  is transitive, but we resolve this by 
treating such evolution as a metametalevel concern. Alternat ively, we may handle such very rare cases by moving the 
embedded alethic operators down to domain-level predicates (e.g., is necessary ) in a similar fashion to the way we deal with 
embedded deontics (see later).  
24.2.1.6 Static, Deontic Constraints
Constraint formulations may make use of the standard deontic modal operators ( O = it is obligatory that; P = it is permitted 
that) as well as F = it is forbidden that (defined as ~ P, i.e., “It is not permitted that”). 
If the rule formulation includes exactly one deontic operator, O, and this is at the front, then the rule may be formalized as Op, 
where p is a first-order formula that is tagged as obligatory (rather th an necessary). For the purposes of this sub clause, this tag 
is assigned only the following informal semantics: it ought to be the case that p (for all future states of  the fact model, until the 
constraint is revoked or changed). The implementation impact is that it is possible to have a st ate in which the rule is violat ed 
(i.e., not satisfied), in which case some appropriate action (cur rently unspecified) ought to be taken to help reduce the chanc e 
of future violations.
From a model-theoretic perspective, a model is an interpretation where each non-deontic formula evaluates to true, and the 
model is classified as a permitted model  if the p in each deontic formula (of the form Op) evaluates to true, otherwise the 
model is a forbidden model  (though it is still a model). Note that this appro ach removes any need to assign a truth value to 
expressions of the form Op.For example, the embedded formulation “ ∀x:Person □ ∃0..1y:Country x was born in y” (For each  Person, it is 
necessary that that  Person was born in at most one  Country.) may be transformed into “ □∀x:Person 
∃0..1y:Country x was born in y” (It is necessary that each Person was born in at most one Country.).
For example, suppose the fact type Person is a husband of Person is declared to be many to many, but that 
each role of this fact type has a deontic uniquen ess constraint to indicate that the fact type ought  to be 1:1. The 
deontic constraint on the husband fact type role verbalizes as: It is obligatory that each  Person is a husband 
of at most one  Person. This formalizes as O∀x:Person ∃0..1y:Person x is a husband of y, which may be 
captured by entering the rule body as ∀x:Person ∃0..1y:Person x is a husband of y and tagging the rule body as 
deontic. The other deontic constraint (each wife should have at most one husband) may be handled in a similar 
way. A more detailed treatment of this example is included in Annex J.
Semantics of Business Vocabula ry and Business Rules, v1.3        237Note that some formulae allowed by SBVR are illegal in some  deontic logics (e.g., iterating modal operators such as OPp is 
forbidden in von Wright’s deontic logic), and deontic logic itself is “rife with disagreements about what should be the case” 
[Girl2000, p. 173].
If a deontic modal operator is embedded la ter in the rule formulation,  we first try to “normali ze” the formula by moving the 
modal operator to the front, using transformation rules such as p ⊃ Oq .≡. O(p ⊃ q) or deontic counterparts to the Barcan 
formulae.
In some cases, a formula for a static ru le might contain an embedded deontic modality that cannot be eliminated by 
transformation. In this case, we still allow the business user to  express the rule at a high level using such embedded deontic 
operators, but where possible we transform the formula to a first-order formula without modalities by replacing the modal 
operators by predicates at  the business domain level . These predicates (e.g., is forbidden)  are treated like any other predicate 
in the domain, except that their names are reserved, and they ar e given some basic additional formal semantics to capture the 
deontic modal negation rules: it is not obligatory that ≡ it is permitted that it is not the case that (~ Op ≡ P~p); it is not permitted 
that ≡ it is obligatory that it is not the case that (~ Pp ≡ O~p). For example, these rules entail an exclusion cons traint between 
the predicates is forbi dden and is permitted. 
This latter approach may also be used as  an alternative to tagging a rule body as deontic, thereby (where possible) moving 
deontic aspects out of the metamodel and into the business domain model.
238                 Semantics of Business Vocabulary and Business Rules, v1.3 
For example, consider the following rule:
Car rentals ought not be issued to people who are barred drivers at the time the rental was issued. 
This deontic constraint may be captured by the following textual constraint on the domain fact type CarRental is 
forbidden: 
CarRental is forbidden if 
CarRental was issued at Time and
 CarRental was issued to Person and
Person is a barred driver at Time.
The fact type Person is a barred driver at Time is deri ved from other fact types (Person was barred at Time, 
Person was unbarred at Time) using the derivation rule: 
Person is a barred driver at Time1 iff
    Person was barred at a Time2 <= Time1 and
    Person was not unbarred at a Time3 between  Time2 and Time1.
The deontic constraint may be forma lized by the first-order formula: ∀x:CarRental ∀y:Person ∀t:Time [( x was 
issued at t & x was issued to y & y is a barred driver at t) ⊃ x is forbidden]. This sche ma allows for the possible 
existence of forbidden car rentals; if desired, some fact  types could be added to describe actions (e.g., sending 
messages) to be taken in reaction to such an event. 
As a second example, consider the following deontic rule: 
It is forbidden that more than three people are on the EU-Rent Board. 
Suppose the underlying schema includes the fact type: Pe rson is on Board. This may be used to define the 
derived fact type Board has NrMembers using the derivation rule: nrMembers of Board = count each Person 
who is on Board. Objectify this derived fact type  as BoardHavingSize, an d then add the fact type 
BoardHavingSize is forbidden. The d eontic constraint may now be captured by the following textual constraint 
on the derived fact type:
BoardHavingSize is forbidden  if 
BoardHavingSize is of a Board
that has BoardName ‘EU-Rent Board’
 and has NrMembers > 3.
Semantics of Business Vocabula ry and Business Rules, v1.3        239The approach to objectification described here works for thos e cases where a fact (propositi on taken to be true) is being 
objectified (which covers the usual cases of nominalization,  including the EU-Rent Board and current marriage examples 
discussed earlier), but it does not ha ndle cases where no factual claim is  being made of the proposition.
SBVR is intended to cater for rules that embed possibly non- factual propositions. However, ther e does not appear to be any 
simple solution to providing explicit, formal semantics for such rules. As a third example, our earlier schema for current marriage may be recast by.objectifying the fact type Person is 
a husband of Person as CurrentMarriage, and recogni zing the link fact types Person is a husband in 
CurrentMarriage and Person is a wife in CurrentMarriag e. The deontic constraints may now be formulated as 
textual constraints on the fact type CurrentMarriage is forbidden as follows: 
CurrentMarriage is forbidden if
a Person1 who is a husband in CurrentMarriage
is a husband of more than one  Person2.
  CurrentMarriage is forbidden if
a Person1 who is a wife in CurrentMarriage
is a wife of more than one  Person2.
Extended treatments of the examples above are provided in Annex J.
240                 Semantics of Business Vocabulary and Business Rules, v1.3Alternatively, we could capture the structure of the rule using the current semantic formulation machinery, and then adopt one 
of two extremes: (1) treat the rule overall as an uninterpreted sentence, or informal comment, for which humans are to provide 
the semantics; (2) translate the semantic formulation directly into higher-order logic, which permits logical formulations 
(which connote propositions) to be predicated over. The complexity and implementation overhead of option (2) would seem to be very substantial. 
We could try to push such cases down to first-order logic by providing the equivalent of the semantic formulation machinery 
as a predefined package that may be imported into a domain mode l, and then identifying propositions by means of a structured 
logical formulation. But that seems a fudge, because in order to assign  formal semantics to such  expressions, we must 
effectively adopt the higher-order logic proposal mentioned in the previous paragraph.As a nasty example, consider the following business rule:
It is not permitted that some department adopts a rule th at says it is obligatory that each employee of that 
department is male. 
This example includes the mention (rather than use)  of an open proposition in the scope of an embedded 
deontic operator. One possible, though weak, solution is to rely on reserved domain predicates to carry much of 
the semantics implicitly. For example, suppose the schema includes the following fact types: Person is male; 
Person works for Department; Department adopts Log ic Rule. Objectify Department adopts Rule as 
RuleAdoption, and add the following fact types: RuleAdoptio n is forbidden; Rule obligates the actualization of 
PossibleAllMaleState; PossibleAllMaleState is actual . This uses the special predicates “obligates the 
actualization of” and “is actual,” as well as a type of  individual “PossibleAllMaleState” which includes all 
conceivable all-male-states of departments, whether actual  or not. The derived fact type PossibleAllMaleState is 
actual may be defined using the derivation rule:
PossibleAllMaleState is actual iff
PossibleAllMaleState is of a Department and
each  Person who works for that Department is male.
i.e., ∀x:PossibleAllMaleState [ x is actual ≡ ∃y:Department ( x is of y & ∀z:Person ( z works for y ⊃ z is male))]. 
The deontic constraint may now be captured by the followi ng textual constraint on t he fact type RuleAdoption is 
forbidden:
RuleAdoption is forbidden if
 RuleAdoption is by a Department
                   and is of a Rule
 that  obligates the actualization of a PossibleAllMaleState
that is of the same  Department.
i.e., ∀x:RuleAdoption ∀y:Department ∀
z:Rule ∀w:PossibleAllMaleState [( x is by y  &  x is of z  &  z obligates the 
actualization of w  &  w is of y)  ⊃  x is forbidden]
The formalization of the deontic constraint works, becau se the relevant instance of PossibleAllMaleState exists, 
regardless of whether or not the relevant depart actually is all male. The “obligates the actualization of” and “is 
actual” predicates embed a lot of semantics, which is  left implicit. While the connection between these 
predicates is left informal, the deriva tion rule for PossibleAllMaleState is actual provides enough semantics to 
enable human readers to understand the intent. An extended treatment of this example is provided in Annex J.  
Semantics of Business Vocabula ry and Business Rules, v1.3        241Pat Hayes has indicated his intent to add support for reification as an extension to Common Logi c at some future date. This 
support is intended to cater for objectification of propositions that are already being asserted as facts (i.e., propositions b eing 
used), as well as propositions for which no  factual claim is made (i.e., propositions being mentioned). When available, his 
treatment for the latter case may offer a better solution for the problem under consideration. His intent is to allow quantification and predication ov er propositions (or expressions that declare propositions), regardless of whether truth claims  
are being asserted of those propositions, while still retaining a first-order approach. We might be able to adopt whatever he 
proposes in this regard to provide a form al semantics for such problematic rules.
24.2.1.7 Derivation Rules
The formal interpretation of SBVR presented here supports rule s for deriving types of individuals (subtype definitions) or fact  
types using either ‘if-and-only-if’ (equivalence) formulations fo r full derivation, or ‘if’ for partial derivation. A subtype m ay 
be fully derived (defined in terms of fact type roles played by its supertype), asserted (without a derivation rule), or partly  
derived.
24.2.1.8 Dynamic Constraints
Dynamic constraints apply restrictions on possible transitions  between business states. The co nstraint may simply compare 
one state to the next. Here is one simple example of each kind of derivation rule, stated first us ing a high-level textual language, as 
described earlier, and then recast as a predicate logic formula. The transformation from a semantic formulation 
structure in a high level language into  predicate logic is straightforward.
Derivation rule for fully derived subtype:
Each  Australian is a Person who was born in Country ‘AU.’
∀x [Australian x  ≡  (Person x & ∃y:Country ∃z:CountryCode ( x is a citizen of y & y has z & z = ‘AU’))]  
Derivation rule for partly derived subtype:
Person
1 is a Grandparent if Person1 is a parent of some  Person2 who is a parent of some  Person3. 
∀x:Person [Grandparent x  ⊂  ∃y:Person ∃z:Person ( x is a parent of y & y is a parent of z)] 
Derivation rule for fu lly derived fact type:
Person1 is an uncle of Person2 iff Person1 is a brother of some  Person3 who is a parent of Person2.
∀x:Person ∀y:Person [x is an uncle of y  ≡  ∃z:Person ( x is a brother of z & z is a parent of y)] 
Derivation rule for partly derived fact type:
If a Patient smokes then that Patient is cancer-prone. 
∀x:Patient (smokes x  ⊃ cancer-prone x )
Salaries should never decrease.
242                 Semantics of Business Vocabulary and Business Rules, v1.3Alternatively, the constraint may comp are states separated by a given period. 
There are two issues here. First, what tran sformation rules did we rely on to license the transformation of the rule? It would 
seem that we require an equivalence rule such as p ⊃ Oq .≡. O(p ⊃ q). While this formula is actually illegal in some deontic 
logics, it does seem intu itively acceptable. At any rate, the preliminary transformati on work in normalizing a rule formulation  
might involve more than just the Barcan equivalences or their deontic counterparts. In principle, this issue might be ignored 
for interoperability purposes, so long as the business domain expe rt is able to confirm that th e final, normalized formulation 
(perhaps produced manually by the business rules modeler) agr ees with their intended semantics; it is only the final, 
normalized formulation that is used for exchange with other software tools. 
The second issue concerns the dynamic nature of the rule. Wh ile it is obvious how one may actually implement this logical 
rule in a database system, capturing the formal semantics in an  appropriate logic (e.g., a temporal or dynamic logic) is a hard er 
task. One possibility is to provide a tempor al package that may be imported into a domain model, in order to provide a first-
order logic solution. Another possibility is to adopt a temporal modal logic (e.g., treat a possible world as a sequence of accessible states of the fact model). It ma y well be reasonable to defer decisions on  formal semantics for dynamic rules to a 
later version of the SBVR standard.
24.2.1.9 Higher-order Logic
Currently, SBVR allows users to either stay  with first-order logic, or adopt higher-order logic restricted to Henkin semantics 
(e.g., for dealing with categorization types). In general, stan dard higher-order logic allows quantification over uncountably 
many possible predicates (or functions). If D = the domain of individuals, then the range of any unary predicate variable R is 
the entire power set P( D) (i.e., the set of all subsets of D), the range of any binary predicat e variable is the Cartesian product 
P(D) × P(D), and so on for higher arity predicates. If D includes a denumerable (countable infinite, i.e., | D| = ℵ
0) set, such as 
the natural numbers, then P( D) is uncountably infinite. In contrast, Henkin semantics restricts quantifiers to range over only 
individuals and those predicates  (or functions) that are specifi ed in the universe of discourse (a.k.a. business domain), where  
the n-ary predicates/functions (n > 0) range over a fixed set of  n-ary relations/operations. By restricting the ranges of predi cate 
and function variables, the Henkin interpretation retains cer tain desirable first-order pr operties (e.g., completeness, 
compactness, and the Skolem-Löwenheim theore ms) that are lost in the standard in terpretation of higher-order logic.  
Common Logic adopts the Henkin restriction on quantifier rang es, but does not adopt the Axiom of Comprehension, which 
states that for each proper ty there exists a set of elements havi ng that property, i. e., for any formula φ(x) where x (possibly a 
vector) is free in φ, ∃A∀x[x ∈ A ≡ φ(x)]. The intent of the Comprehension axiom (to ensure that every formula specifies a set) 
may also be achieved by using lambda abstraction to name the set, e.g., λx.φ(x), which is equivalent to the set comprehension 
{x| φ(x)}. The Axiom of Comprehension leads to Russell’s paradox (substituting x ∉ x for φ(x) generates a contradiction since 
{x| x ∉ x} is simultaneously a member of itself and not a member of itself). The paradox may be avoided either by rejecting the Invoices ought to be paid within 30 days of being issued.
The invoice rule might be formally expressed in a hi gh level rules language thus, assuming the fact types 
Invoice was issued on Date and Invoice is paid on Date are included in the conceptual schema:
For each  Invoice, if that  Invoice was issued on Date1 
then it is obligatory that
that Invoice is paid on Date2 where  Date2 <= Date1 + 30 days.
This might now be normalized to the following formul ation, moving the deontic operator to the front:
It is obligatory that each  Invoice  that  was issued on Date1 is paid on Date2  
where  Date2 <= Date1 + 30 days.
Semantics of Business Vocabula ry and Business Rules, v1.3        243comprehension axiom (e.g., repl acing it by the weaker axiom of separation, as in Zermelo-Fraenkel set theory) or by 
restricting the language so  that formulae such as x ∉ x are illegal (as in Russell’s type theory, where a set may belong only to a 
set of higher order).
Here we use set comprehensions (in a restricted sense) to defi ne projections on schema path expressions, as a way to specify 
result sets. 
The use here of set comprehension is quite restricted. Any expression we use to define a set must ultimately be expressible 
only in terms of some basic logical operators (e.g., &) as well as predefined ground fact types which must be either elementary  
or existential. Hence we adopt a limited version of the axiom of comprehension. Common Logic is open to extensions that 
adopt restricted versions of the co mprehension axiom. To avoid Russell’s paradox, we treat formulae such as x ∉ x as illegal. 
The “is an instance of” predicate caters fo r set membership, but is constrained to be  irreflexive, and the formation rules do n ot 
permit expressions of the form x ∈ x – in other words, we cannot make statements involving self-membership. We do not 
adopt a type theory such as Russell’s  type theory, where each set may belong  only to a set of a higher type. 
The decision on whether to use higher-order types mainly impacts the following three aspects of fact modeling: categorization 
schemes, un-normalized structures, and crossing levels/metalev els within the same model. In [Halp2004], some ways are 
suggested to avoid higher-order types, by treating types as in tensional individuals whose instances may sometimes be in 1:1 
correspondence (but not identical) to subtypes, by requiring subtype definitions to be informative, by remodeling (including 
demotion of metadata to data), and by treating types as indivi duals in separate models. For further discussion, see [Halp2004].
Acknowledgement : We gratefully acknowledge th e assistance of Pat Hayes ( http://www.ihmc.us/users/
user.php?UserID=phayes ) in addressing some of the logical semantics topics in this document.
24.2.2 Formal Logic & Mathematics in General
___________________________________________________
Formal Logic and Mathematics Vocabulary
Language: English
___________________________________________________
acceptable world
Definition: any state (situation) of some given universe of discourse (domain) that is implicitly 
characterized, by someone with le gal authority over that domain, as consistent with some set 
of goals of that authority pursued  by exercise of that authorityFor example, given the fact type Employee(EmpNr) wo rks for Company(Name), the query “Who works for 
Microsoft?” corresponds to the following set comprehension:
{x:Employee | ∃ y:Company; z:CompanyName ( x works for y  &  y has z  &  z = ‘Microsoft’)}
The formal semantics of such conceptual queries is ba sed on that of the Conquer language, which provides a 
sugared version of sorted finitary first-or der logic with set comprehension [Anto2001].
244                 Semantics of Business Vocabulary and Business Rules, v1.3actual world
Definition: the possible world that is taken to be actual for some purpose, in particular, for the conduct of 
business and the application of business rules
Note: the actual world is a set of things, situations and facts about them that some person or 
organization takes to be true for some purpose. In  most cases, it is the best estimate of the 
actual state of the world that is of interest at a particular time.
alethic modality
Source: CDP  
Definition: Historically, any of the five central ways or modes in which a given proposition might be true 
or false: necessity  (and non-necessity ), possibility  (and impossibility ), and contingency
Note: (1) Although these “modes” have historically  been thought of as ways in which a proposition 
might be true, we think of them as ways in wh ich one might think of the truth of a proposition: 
e.g., that a proposition be  qualified with the alethic modalit y “necessity” does not imply it is a 
fact, but only signifies that the se mantic community is considering it (takes it to be) necessarily 
true. For some issues arising from the former approach , cf. CDP, s.v. intensional logic . For a 
thorough critique of it, see PEIL. The four “mod al negation equivalences” (MLP, p. 3), such as 
□p ≡ ∼∼p, still hold under the latter approach (cf. LEVS, p. 135), which is the more useful 
one in the fields of linguistic semantics and linguistic pragmatics.
Note: (2) The four alethic modalities which we consider most basic, and to which the four “modal 
negation equivalences” (MLP, p. 3) apply, are necessity , possibility , and their respective 
negations ( non-necessity  and impossibility ).  We also define a fifth modality, contingency  
for the idea “neither impossi ble nor necessary.” (CDP)
Note: (3) Alethic modal logic differs from deontic mo dal logic in that the former deals with people’s 
estimate(s) of the possible truth of some proposition, whereas deontic modal logic deals with people’s estimate(s) of the social desirability  of some particular party’s making some 
proposition true.
antecedent
Source: adapted from GFOL  
Definition: The wff in [or more specifically, the proposition- wff in or else the proposition denoted by] the 
if-clause of an implication .
Note: Interpolation ours. Otherwise the definition is from GFOL.
argument
Source: GFOL  
Definition: a [logical-] subject-term for a predicate .
Note: Interpolation in square brackets ours. By “log ical subject” we mean an object playing a role 
(i.e., an object filling an object  hole) in a logical predicate. Thus there may be one or more 
logical-subject-terms in  a logical predicate.
arity
Source: IMRD (pp. 10, 64)  
Definition: A logical predicate’s number of roles (i.e., of object holes).
Note: A function may be t hought of as a relation; accordingly, we treat a function as a logical 
predicate. MATH defines arity of a function thus: “The number of arguments taken by 
Semantics of Business Vocabula ry and Business Rules, v1.3        245something, usually applied to functions: an n-ary function is one with an arity of n, i.e., it takes 
n arguments. Unary is a synonym for 1-ar y, and binary is a synonym for 2-ary.”
atomic formula
Source: GFOL [“atom”]  
Definition: In predicate logic, a wff without quantifiers  or connectives.
Note: (1) This definition is from the cited source s.v. atom, which we deem a synonym.Note: (2) LSO says of atomic formula: “The simplest sort of wff
 of a formal language; an atomic 
formula of the language of predicate logic is a predicate letter followed by zero or more name 
letters.” Yet it can also be a propositional variable or a propositional constant, depending on context.
consequent  
Source: GFOL  
Definition: The wff in [or more specifically, the proposition- wff in or else the proposition denoted by] the 
then-clause of an implication .
Note: Interpolation ours.
contingency  
Definition: alethic modality  that is the conjunction of possibility  and  non-necessity
Note: Contingency (“it is possi ble but not necessary that p”) is the modal equivalent of “it is neither 
impossible nor necessary that p”: ( p & ~ □p) ≡ ∼ (∼ p v □ p).
deontic modality  
Source: CDP [“deontic operator”]; LEVS (pp. 276-77); LSO (p. 302); MLP (pp. 170-76)  
Definition: Any of the five central ways or modes in which one might think of the social desirability of a 
certain other person(s)’s making true some propositio n, that is, the social desirability that the 
act(s) be performed, by a certain other person(s ), that would make the proposition true; viz., 
obligation  (and its negation, non-obligation ), permission  (and its negation, nonpermission 
(forbidden/ prohibition )), and optionality .
Note: (1) The definition given is not quoted directly from any source, since we have not found the 
term defined as such anywhere. Rather, we have  based our definition on passages mainly in the 
above-cited sources.
Note: (2) Alethic modal logic differs from deontic modal logic in that the former deals with people’s 
estimate(s) of the possible truth of some propo sition, whereas deontic modal logic deals with 
people’s estimate(s) of the so cial desirability of some particular party’s making some 
proposition true.
Note: (3) The four deontic modalities that we consider most basic, and to which the four “modal 
negation equivalences” apply, are obligation , permission , and their respective negations 
(non-obligation  and prohibition ). We also define a fifth modality, optionality , for the idea 
“neither prohibited nor obligatory.” 
domain
Source: GFOL  
Definition: Of an interpretation of a formal language of predicate logic, the set of objects that may serve as 
the assigned referents of the constants of the language, the arguments  of functions, and the 
arguments  of predicates .
246                 Semantics of Business Vocabulary and Business Rules, v1.3domain grammar  
Source: META (p. 4); HALT89 (sec. 3.2); IMRD (pp. 27-30)  
Definition: The formation rules determining what is a wff in a given domain-sp ecific formal language.
Note: Another term for that which is called in ORM “conceptual schema.” The definition given 
above is not quoted directly from any source, since we have not found the term defined as such anywhere. Rather, we have based our definition on passages mainly in the above-cited sources.
elementary verb concept
Definition: verb concept  whose facts  cannot be split into smaller units of information that collectively 
provide the same information as the original
Concept Type: role
Example: branch  has storage capacity
Example: service depot  is included in  local area
Example: rental car  has fuel level  at date/time
Example: Counter-example (this would not be considered an elem entary verb concept):  car 
manufacturer  delivers  consignment  to branch . This is not elementary because a 
consignment is always from at most one car manuf acturer and is always to  at most one branch.  
So the counter-example is equivalent to the combination of two binary verb concepts: car 
manufacturer  delivers  consignment  and consignment  is delivered to  branch .
fact type
Definition: set of all possible facts of a given kind that , in logical terms, corresponds to a set of one or 
more typed predicates that are semantically interchangeable excep t that the order of arguments 
may vary
Example: In prefix notation the typed predicates drives(Person,Car), isDrivenBy(Car, Person), and 
isaDriverOf(Person, Car) could each be used for the same fact type.
first-order instance
Source: GFOL  
Definition: The objects or elements taken as the [logical] subjects of the predicates  of first-order 
predicate logic.
Definition: [CLARIFIED DEFINITION] object or element taken as a logical subject of a predicate of first 
order logic.
Note: And the distinguishing characteristic of “first-o rder” predicate logic, in  turn, is the additional 
restriction, re the formation of wffs, that subjects of predicates  cannot themselves be types  or 
predicates , but rather only individuals (or individual-constants, individual-variables, or 
function-expressions). See first-order type .
first-order type  
Source: LSO (pp. 280-84) [and “type syst em”]; META (p. 140); TTGG (p. 5)  
Definition: A type  whose extension includes no  types or predicates, only first order instances , in 
accordance with the grammatical restric tions in first-order predicate logic.
Note: The definition given is not quoted directly from any source, since we have not found the term 
defined as such anywhere. Rather, we have based our definition on passages mainly in the above-cited sources.
Semantics of Business Vocabula ry and Business Rules, v1.3        247formal model  
Source: based on GFOL [“model”]; META (pp. 5,6, 148-49)  
Definition: An interpretation  supplies semantics (referents) for a given formal language, in relation to 
some domain or universe. It specifies referent s for the nonlogical sy mbols occurring in the 
formal language. A formal model  of a given wff or set of wffs in a formal language is an 
interpretation of the language for which the wffs are considered true.
implication
Source: GFOL  
Definition: expression of the form, “if A, then B,” when A and B stand for wffs or propositions . The wff 
in the if-clause is called the antecedent  (also the implicans and protasis). The wff in the then-
clause is called the consequent  (also the implicate and apodosis). Also called a conditional, 
or a conditional statement.
Note: In SBVR we treat “implication” as if it is “material implication” (i.e., ‘p  q’ is equivalent to 
‘~p v q’).
impossibility  
Definition: alethic modality  that is the negation of possibility
Note: A derived modal operator  for ‘impossibility’ may be used in the surface syntax, but it is 
translated into the basic modal operator for ‘possibility’ plus negation (~) (i.e., “It is 
impossible that p” is defined as “It is not possible that p”:  ~ p).
Note: Impossibility (“it is impossible that p”) is the modal equivalent of  “it is necessary that not p”: 
~p ≡  □ ~p.
integer
Source: GFOL [“integers”]  
The natural numbers supplemented by their negative counterparts. The set {...-3, -2, -1, 0, 1, 2, 
3...}.
logical variable  
Source: GFOL  
Definition: A symbol whose referent varies or is unknown. A place-holder,  as opposed to an abbreviation 
or name (a constant).
Note: This definition is from the cited source s.v. variable, which we deem a synonym.
member  
Source: DEAN (p. 6); GFOL [“membership”]  
Definition: An element belonging to a set.
Note: The definition given is not quoted directly from any source, since we have not found the term 
defined as such anywhere. Rather, we have ba sed our definition on passages mainly in the 
above-cited sources.
modal logic
Source: SEP 
Definition: Narrowly construed, modal logic studies reasoning that involves the use of the expressions 
‘necessarily’ and ‘possibly.’ Howeve r, the term ‘modal logic’ is used more broadly to cover a 
family of logics with similar rules and a variety of different symbols.
248                 Semantics of Business Vocabulary and Business Rules, v1.3necessity
Source: CDP  
Definition: A modal property that qualifies an assertion of a whole proposition just when it is not 
considered possible that the proposition is false.
Note: The definition given is not quoted directly  from any source. Rather, we have based our 
definition on passages mainly in the above-cited source. See also alethic modality
Note: Necessity (“it is necessary that p”) is the modal equivalent of “it is not possible that  
not p”: □≡ ~∼p.
Note: The following modal negation rules  apply:  
“it is not necessary that p” ≡ “it is possible that not p”:  ~□p ≡ ∼p. See non-necessity
non-necessity
Definition: alethic modality  that is the negation of necessity
Note: Non-necessity (“it is not necessary that p”) is the modal equivalent of “it is possible that  
not p”:  ~ □p≡ ∼p
non-obligation
Definition: deontic modality  that is the negation of obligation .
Note: Non-obligation (“it is not obligatory that p”) is the modal equivalent of “it is permitted that  
not p”:  ~Op ≡ P~p.
obligation
Source: CDP [“deontic logic”]; MLP (pp. 170-76)  
Definition: One of the four main deontic modalities , which qualifies as socially obligatory the making 
true a certain proposition (i.e., the doing a certain act) by a certain party or parties.
Note: The definition given is not quoted directly from any source, since we have not found the term 
defined as such anywhere. Rather, we have based our definition on passages mainly in the above-cited sources.
Note: Obligation (“it is obligatory that p”) is th e modal equivalent of “it is not permitted that  
not p”: Op ≡ ∼P~p
Note: The following modal negation rules apply:  
“it is not obligatory that p” ≡ “it is permitted that not p”: ~ Op ≡ P~p.  See non-obligation
.
optionality
Definition: deontic modality  that is the conjunction of permission  and non-obligation
Note: Optionality (“it is permitted but not obligatory that p”) is the modal equivalent of  “it is neither  
prohibited nor obligatory that p”: (Pp & ~Op ≡ ∼ (∼ Pp v Op).
permission
Source: CDP [“deontic logic”]; MLP (pp. 170-76)  
Definition: One of the four main deontic modalities , which qualifies as socially permissible the making 
true a certain proposition (i.e., the doing a certain act) by a certain party or parties.
Note: The definition given is not quoted directly from any source, since we have not found the term 
defined as such anywhere. Rather, we have based our definition on passages mainly in the above-cited sources.
Semantics of Business Vocabula ry and Business Rules, v1.3        249Note: Permission (it is permitted that p”) is the modal equivalent of “it is not obligatory that  
not p”: Pp ≡ ~O~p.
Note: The following model negation rules apply:  
“it is not permitted that p” ≡ “it is obligatory that not p”:  ~Pp ≡ O~p. See prohibition .
population
Source: IMRD (p. 164)  
Definition: The extension of a type  (whether type of individual, fact type, or role) for a given state of the 
business domain.
possibility
Source: CDP  
Definition: A modal property that qualifies an assertion of a whole proposition just when it is considered 
possible that the proposition is true.
Note: The definition given is not quoted direct ly from any source. Rather, we have based our 
definition on passages mainly in the above-cited source. See also alethic modality
Note: Possibility (“it is possible that p”) is the modal equivalent of  “it is not necessary that  
not p”:  p ≡ ∼□∼p.
Note: The following modal negation rules  apply:  
“it is not possible that p” ≡ “it is necessary that not p”:  ~p ≡ □∼p. See impossibility .
possible world
Definition: any state (situation) of some given universe of discourse (domain) that is implicitly 
characterized, by an accepted expert on that domain , as logically consistent with some set of 
laws seen by that expert as applying to that domain
Note: “Possible world” means “logically possible world,” and not “physically possible world.” 
Included within the sense of “possible world” is any “possible situation;” therefore, the notion includes the “possible states” of any given set of objects [ things
] of interest - which set is 
commonly called the “Universe of Discourse” (or “UoD”), a.k.a. the “domain” (or “business 
domain”). Thus, in the co ntext of a static constraint decl ared for a given business domain, a 
“possible world” would correspond to (but not be identical to) a stat e of the domain’s fact 
model that could exist at some point in time, which is the “present time” of the possible world.
predicate
Source: GFOL  
Definition: Intuitively, whatever is said of the s ubject[s] of a sentence - function from individuals (or a 
sequence of individuals) to truth-values
Note: Interpolation in square brackets ours. A pred icate is distinguished from others by sentence 
structure, not by proposition/meaning (see IM RD, pp. 63-66). Propositions or meanings 
distinguish fact types, each of whic h may have 1 or more predicates.
prohibition
Source: CDP [“deontic logic”]; MLP (pp. 170-76)  
Definition: One of the four main deontic modalities  nonpermissibility, which qualifies as socially not 
permissible the making true a certain proposition (i.e., the doing a certain act) by a certain party or parties
Definition: deontic modality
 that is the negation of permission
250                 Semantics of Business Vocabulary and Business Rules, v1.3Note: See also permission . The definition given is not quoted directly from any source, since we 
have not found the term defined as such anywhere. Rather, we have based our definition on passages mainly in the above-cited sources.
Note: A derived modal operator  for ‘prohibition’ may be used in the surface syntax, but it is 
translated into the basic modal operator for ‘permission’ plus negation (~). (i.e., “It is prohibited that p” is defined as “It is not permitted that p”:  ~Pp).
Note: A derived modal operator  for ‘forbidden’ may be used in the surface syntax, but it is translated 
into the basic modal operator fo r ‘permission’ plus negation (~). (i.e., “It is forbidden that p” 
(Fp) is defined as “It is not permitted that p”:  ~Pp).
Note: Prohibition (“it is prohibited that p”) is the modal equivalent of “it is obligatory that  
not p”: ~Pp ≡ O~p.
proposition
Source: DL (p. 4)  
Definition: That which is asserted when a sentence is uttered or inscribed
Note: Generally understood as “the  meaning of” a declarative senten ce. GFOL defines it thus: “In 
logic generally (for some), the meaning of a sentence that is invariant through all the paraphrases and translations of the sentence.”
propositional operator
Source: PLTS  
Definition: An operator (or connective) joins … statements [i.e., propositions or proposition- wffs] into 
compounds…. Connectives include conjunction, disjunction, implication and equivalence. Negation is the only operator that is not a conn ective; it affects sing le statements [i.e., 
propositions or proposition- wffs
] only, and does not join statements [i.e., propositions or 
proposition- wffs] into compounds.
Note: By “proposition- wff” we mean a proposition-constant or proposition-variable, or a predicate 
supplied with arguments so as to yield a proposition.
quantifier
Source: GFOL  
Definition: In predicate logic, a symbol telling us … how many objects (in the domain) [instantiate] the 
predicate…. The quantifier applies to, or  binds, variables which stand as the arguments  of 
predicates . In first-order logic these variables must range over individuals ; in higher-order 
logics they may range over predicates . 
Note: Interpolation in square brackets ours.
restricted higher-order instance
Source: HALT2004 (pp. 2-4, 7); MEN97 (pp. 378-80)  
Definition: instance of a restricted higher-order type
Note: The definition given is not quoted directly from any source, since we have not found the term 
defined as such anywhere. Rather, we have based our definition on passages mainly in the above-cited sources.
Semantics of Business Vocabula ry and Business Rules, v1.3        251restricted higher-order type
Source: HALT2004 (pp. 2-4, 7, 8); MEN97 (pp. 378-80)  
Definition: A higher-order type  includes an instance that is itself a type . For SBVR, we restrict higher-
order types  to Henkin semantics, limiting the range of predicates /functions over which we 
may quantify to a fixed set, rather than allowing full range over power-sets. This restriction 
retains useful properties of first-order logic (e.g., completeness).
Note: The definition given is not quoted directly from any source, since we have not found the term 
defined as such anywhere. Rather, we have ba sed our definition on passages mainly in the 
above-cited sources. 
set
Source: GFOL  
Definition: Intuitively, a coll ection of elements (called members ). In a set, the order of members  is 
irrelevant, and repetition of members  is [also irrelevant]. The intuitive notion of a set leads to 
paradoxes, and there is considerable mathem atical and philosophical disagreement on how 
best to refine the intuitive notion.
Note: Interpolation in square brackets ours.
state of affairs
Source: CDP  
Definition: A possibility, actuality or impossibility of the kind expressed by a nominalization of a 
declarative sentence (e.g., “Thi s die comes up six” may be nominalized by “that this die comes 
up six” or “this die’s coming up six”) the resulting nominalizations might be interpreted as naming corresponding propositio ns or states of affairs
subset
Source: GFOL  
Definition: set all of whose members belong to a second set (a superset of the subset)
type
Source: adapted from HALT2004 (p. 8); cf. TTGG (p. 84)  
Definition: named set of possible instances , where for any given state of the business domain, exactly one 
subset  of the type is the population  of the type in that state
Note: At any given time, the population  of a type is the set of instances  of that type that exist in the 
business domain (i.e., that are re ferenced within facts that are kn own and are of interest to the 
business) at that time. It follows  that if two types are equal, th en for each state of the business 
domain they must have the same population.
Note: “Possible instances” here means “instances whic h are considered part of the type’s population, 
for some state of the business domain.”
Note: Because it is a formal object that behaves quite differently in first-order predicate logic than in 
second-order predicate logic (and differently still  in third order, and so on), the definition of 
“type” proves to be anaphoric, having a different denotation depending on whether, in the situation where used, the intended formalization is first-order, s econd-order, or other-order. In 
our definitions of first-order type
 and restricted higher order type , at least some of this 
indefiniteness is removed (by the specifying of either first-order logic or restricted higher-
order logic).
252                 Semantics of Business Vocabulary and Business Rules, v1.3type of individual
Definition: type  that is a set of possible individuals; kind of individual thing, e.g., Planet, CountryCode
unbound variable
Source: GFOL  
Definition: free variable [which, in GFOL, is defined thus :] in predicate logic, an individual variable at 
least one of whose occurrences in a wff does not lie within the scope of a quantifier  on the 
same letter
Universe of Discourse
Definition: set of objects [ things ] of interest, including their states, relationships, and situations and 
forming the context of a given discussion
wff
Source: GFOL  
Definition: (acronym of “well-formed  formula”) - a string of symbols, each from the alphabet of a formal 
language, that conforms to the grammar of the fo rmal language; in predicate logic, a closed wff 
is a wff with no free occurrences of any variable; eith er it has constants in place of variables, or 
its variables are bound, or both (also called a sentence); an open wff is a wff with at least one 
free occurrence of a variable
world
Source: CSILL  
Definition: a universe, whether real, imaginary, or hypothetical
Note: From CSILL: The truth-conditional approach to meaning allows model theory to be extended 
to the study of natural languages. Sentences an d their parts are mapped on to elements of a 
model, which represents the truth-conditions fo r the sentences. In possible world semantics, 
models are not restricted to domai ns of real entities but include possible objects; that is, model 
theory can provide truth-conditions in terms of possible worlds, thus allowing meaningful 
expressions without requiring ontological commitment.
24.2.2.1 Conceptual Schemas and Models
conceptual schema  
Definition: combination of concepts and facts (with sema ntic formulations that define them) of what is 
possible, necessary, permissible, a nd obligatory in each possible world
conceptual schema  includes concept  
Definition: the concept  is used in models based on the conceptual schema
Synonymous Form: concept  is in conceptual schema
Necessity: Each role of each  fact type  that is in a conceptual schema  is in the conceptual  
schema .
conceptual schema  includes fact  
Definition: the fact determines something possible, necessary, pe rmissible, or obligatory in each possible 
world that can be modeled based on the conceptual schema
Synonymous Form: fact is in conceptual schema
Semantics of Business Vocabula ry and Business Rules, v1.3        253fact type  is internally closed in conceptual schema  
Definition: in each fact model  based on the conceptual schema , for each instance of the fact type , the 
fact model  includes a corresponding fact if, for each thi ng filling any of the fact type’s roles in 
the instance, the fact model  also includes a fact of th e existence of that thing
Synonymous Form: fact type  is semi-closed in conceptual schema
Note: Open world semantics are assumed by default, but closure may be explicitly asserted for any 
fact type, on an individual basis, to declare that  each fact model population agrees with that of 
the fact type’s extension in the actual business domain. Semi-closure is with respect to the 
domain model population of the noun concepts playing a role in the fact type.  In other words, if the things participating in a fact are known within a model, then the fact is also known 
within that model.
concept  is closed in conceptual schema  
Definition: in each fact model  based on the conceptual schema , the entire extension of the concept  is 
given in the facts included in the fact model
Necessity: Each concept  that is closed in a conceptual schema  is in the conceptual schema .
Note: A concept can be closed in one co nceptual schema and not in another. 
fact model
Definition: combination of a conceptual  schema and, for one possible world, a set of facts (defined by 
semantic formulations using only the concepts of the conceptual schema)
Synonym: conceptual model
Note: Each necessity of the conceptual schema is satisfied by a fact model,  but obligations are not 
necessarily satisfied.
fact model  is based on conceptual schema
Definition: the conceptual schema  provides the concepts and modal facts of the fact model
Synonymous Form: conceptual schema  underlies  fact model
fact model  includes fact  
Definition: the fact corresponds to an actuality in the possible world modeled by the fact model
Synonymous Form: fact is in fact model
fact type  has fact in fact model
Definition: the fact is in the fact model  and the fact corresponds to  an instance  of the fact type
fact type  is elementary in conceptual schema
Definition: the fact type  is in the conceptual schema  and cannot be decomposed into a set of two or 
more fact types  that are in the conceptual schema  and that collectively have the same 
meaning as the fact type
Synonymous Form: conceptual schema  has elementary fact type
24.3 Formal Logic Interpretati on Placed on SBVR Terms
This clause specifies how the SBVR concepts in the table below,  as defined in Clauses 8 through 21, are to be interpreted in 
terms of formal logic as defined in ISO 24707 “Information tec hnology - Common Logic (CL) - A framework for a family of 
logic-based languages.” Equivalent concepts in OWL are also shown in the table where possible.
254                 Semantics of Business Vocabulary and Business Rules, v1.3The ISO 24707 interpretation of SBVR concepts shown in the ta ble below implements the formal logic grounding principles 
set forth in sub clause 24.2.
Note : The cells that are empty will be specified in a future revision of this specification. 
Note : All SBVR Terms are “meanings” where al l CL Terms are “representations of m eanings.” Therefore there is a one-to-
many relationship between SBVR Terms as meanings and CL Terms as representations of meanings ; i.e., there can be multiple 
CL representations of one SBVR meaning. 
SBVR Term ISO CL Term (or equivalent 
expression)OWL Term (or equivalent 
expression)Comment
BASICS - Foundation
fact sentence with an interpretation 
'taken to be' true
NOTE: The mapping is many (sentences) to one (meaning)OWL statement ( s, p, o ) 
interpreted as being true; 
individual
verb concept
(3+ary) + (characteristic)unary predicate defining the type 
for a functional term or atomic 
sentence ---
verb concept
(binary verb concept)unary predicate defining the type 
for a functional term or atomic 
sentence that has exactly two argumentsClass description defining RDF 
property or OWL object property 
(note: may only apply to OWL Full)Need 2 RDF/OWL 
properties related 
by inverse of = one binary verb concept
verb concept  has verb   
concept roleargument role in functional term 
or atomic sentence---
verb concept  has verb   
concept role
(binary verb concept)argument role in functional term 
or atomic sentence that has 
exactly two argumentsthe range of an rdf:Property or 
owl:ObjectProperty; 
alternatively, may be specified using a restriction on the 
property in OWL
verb concept role unary predicate defining the role of a name/term that is an 
argumentRDF/OWL subject or object
verb concept role  ranges 
over general concept
(role ranges over general 
concept)term over which argument 
rangesvalue restriction on property
fundamental concept
individual noun concept name individual
general concept unary predicate class
proposition sentence with an interpretation OWL statement ( s, p, o ); 
individual 
Semantics of Business Vocabula ry and Business Rules, v1.3        255proposition  is false sentence with an interpretation = 
falseOWL statement ( s, p, o ) 
interpreted as being false; individual 
proposition  is true sentence with an interpretation = 
trueOWL statement ( s, p, o ) 
interpreted as being true; 
individual 
reference scheme approximately term
reference scheme   
extensionally uses role
reference scheme  is for 
concept
reference scheme  simply 
uses role
reference scheme  uses 
characteristic
situational role  unary predicate defining the role 
of a name/term that is an 
argumentRDF/OWL subject or object
situational role  ranges 
over fundamental   
concept
(role ranges over general 
concept)term over which argument 
rangesvalue restriction on property
BASICS - Extension in Model
NOTE: There are two kinds of extensions in SBVR:
  1.  Real things that never appear in an SBVR Model themselves  
  2.  Model extensions:  
         a.  Individual noun concepts as model instances of general  concepts (fundamental  
              concepts only)  
         b.  facts as model instances of verb concepts
concept1 is coextensive 
with concept2 (verb 
concept)(forall (p1 p2) (if (and (binary 
verb concept p1 ) (binary verb 
concept p2)) (iff (is coextensive 
with p1 p2) (forall (x y) (iff (p1 x y) 
(p2 x y))))))owl:equivalentProperty
concept1 is coextensive 
with concept2 (noun 
concept)(forall (c1 c2) (if (and (noun 
concept c1) (noun concept c2)) (iff (is coextensive with c1 c2) 
(forall (x) (iff (c1 x) (c2 x))))))owl:equivalentClass
concept  has extension  
(verb concept / verb concept)“sentence type” has extension
256                 Semantics of Business Vocabulary and Business Rules, v1.3concept  has extension  
(noun concept)((forall (x)(iff  
    (concept x)  
   (or (= aaa-1 x) ... (= aaa-n x) ) 
)) enumeration of a class (OWL 
one Of)
extension extension class
proposition  corresponds 
to state of affairs  approximately sentence 
denotation
concept  has instance atom (concept thing) can be specified via an rdf:type 
statement ( i.e., thing rdf:type 
concept.)
set set
BASICS - Intension:  
Characteristic
characteristic (see characteristic) (see charac teristic) (see characteristic)
characteristic  is essential 
to concept
characteristic type
concept  has implied   
characteristic
concept  has necessary  
characteristic
concept  incorporates 
characteristicsentence
(forall (u)(implies(characteristic 
u)(concept u)))rdfs:subClassOf
delimiting characteristic
essential characteristic
implied characteristic
intension intension
necessary characteristic
BASICS - Intension:   Categorization
categorization scheme
categorization type
category
concept type unary predicate class
Semantics of Business Vocabula ry and Business Rules, v1.3        257concept1 specializes 
concept2
(binary verb concept)(forall (p1 p2) (if (and (binary 
verb concept p1 ) (binary verb 
concept p2) (iff (specializes p1 
p2) ((forall (x y) (if (p1 x y) (p2 x 
y)))))))rdfs:subPropertyOf + disjoint
concept1 specializes 
concept2
(noun concept)(forall (c1 c2) (if (specializes c1 
c2) (forall (x) (if (c1 x) (c2 x)))))  
(forall (c1 c2) (if (and 
(specializes c1 c2) (specializes c2 c3)) (specializes c1 c3)))rdfs:subClassOf + disjoint One way from 
SBVR to CL
more general concept
segmentation
BASICS - Modal Logic
element of guidance   
authorizes state of affairs
element of guidance   
obligates state of affairs
element of guidance   
prohibits state of affairs
operative business rule
proposition  is necessarily 
true
proposition  is obligated 
to be true
proposition  is permitted 
to be true
proposition  is possibly 
true
rule
structural rule
BASICS - Misc.
quantity1 is less than 
quantity2functional term with operator “is 
less than” and arguments 
quantity1 and quantity2
258                 Semantics of Business Vocabulary and Business Rules, v1.3integer atom (integer x) xsd:integer There are no 
explicitly defined types in CL; there is 
specific set of XML 
schema datatypes 
available for use 
with RDF and OWL
nonnegative integer atom (nonnegative integer x) xsd:nonNegativeInteger
number atom (number x)
positive integer atom (positive integer x) xsd:positiveInteger
quantity
SEMANTIC FORMULATIONS
aggregation formulation
antecedent
at-least-n-quantification restriction, owl:minCardinality n
at-least-n-quantification  
has minimum cardinality
at-most-n-quantification restriction, owl:maxCardinality n
at-most-n-quantification  
has maximum cardinality
at-most-one-  
quantificationrestriction, owl:maxCardinality 1
atomic formulation atomic sentence or atom if unary - rdf:type  
if binary - rdf;triple  
nothing not 3+
atomic formulation  has 
role binding
atomic formulation  is 
based on verb concept
auxiliary variable
bag projection
binary logical operation
binary logical operation  
has logical operand 1
binary logical operation  
has logical operand 2
bindable target
Semantics of Business Vocabula ry and Business Rules, v1.3        259cardinality owl:cardinality
closed logical   
formulationsentence with an interpretation
closed logical   
formulation  formalizes 
statement
closed logical   
formulation  means  
proposition
closed projection
closed projection   
defines verb concept
closed projection   
defines noun concept
closed projection   
means question
closed semantic   
formulation
conjunction conjunction with at least two 
conjunctsowl:intersectionOf about the 
extension of a concept and not 
about the meaning of a 
sentence
consequent
disjunction disjunction with at least two disjunctsowl:unionOf *
equivalence biconditional roughly owl:equivalentProperty
exactly-n quantification restriction, ow l:cardinality n
exactly-n quantification  
has cardinality
exactly-one  
quantificationrestriction, ow l:cardinality 1
exclusive disjunction negation of biconditional ---
existential quantification quantified sentence of type 
existentialrestriction, 
owl:someValuesFrom
implication implication ---
implication  has  
antecedent
260                 Semantics of Business Vocabulary and Business Rules, v1.3implication  has  
consequent
inconsequent
instantiation formulation atomic sentence or atom rdf:type
instantiation formulation  
binds to bindable target
instantiation formulation  
considers concept
logical formulation sentence
logical formulation   
constrains projection
logical formulation kind
logical formulation   
restricts variableowl:Restriction  - for specific 
kinds of restrictions (value, number)
logical negation negation roughly owl:complementOf
logical operand argument of a functional term
logical operand 1 argument of a functional term, first in sequence
logical operand 2 argument of a functional term, 
second in sequence
logical operation term representing the operation 
for a functional term
logical operation  has  
logical operand
maximum cardinality owl:maxCardinality
minimum cardinality owl:minCardinality
modal formulation irregular sentence ---
modal formulation   
embeds logical   
formulation
nand formulation negation of conjunction ---
necessity formulation
nor formulation negation of disjunction ---
noun concept formulation
Semantics of Business Vocabula ry and Business Rules, v1.3        261numeric range   
quantificationrestriction, owl:minCardinality n 
AND restriction, owl:maxCardinality m
numeric range   
quantification  has  
maximum cardinality
numeric range   
quantification  has  
minimum cardinality
objectification
objectification  binds to 
bindable target
objectification  considers 
logical formulation
obligation formulation
permissibility formulation
possibility formulation
projecting formulation
projecting formulation  
binds to bindable target
projecting formulation  
has projection
projection
projection  has auxiliary  
variable
projection  is on variable
projection position
quantification quantified sentence
quantification  introduces 
variableapproximately binding sequence 
for quantified sentence
quantification  scopes 
over logical formulationbody for quantified sentence
role binding binding sequence
role binding  binds to 
bindable targetbinding
role has role binding
262                 Semantics of Business Vocabulary and Business Rules, v1.3scope formulation
semantic formulation
set has cardinality
set projection
universal quantification quantified sentence of type 
universalrestriction, owl:allValuesFrom
variable name/term individual or blank node
variable  has projection  
position
variable  is free within  
semantic formulation
variable  is unitary approximately a functional 
property
variable  ranges over  
concept---
whether-or-not   
formulationtruth function operation ---
whether-or-not   
formulation  has  
consequent
whether-or-not   
formulation  has  
inconsequent
SEMANTIC FORMULATION  - Nominalization
answer nominalization
verb concept  
nominalization
proposition   
nominalization
proposition   
nominalization  binds to 
bindable target
proposition   
nominalization  considers 
logical formulation
question   
nominalization
Semantics of Business Vocabula ry and Business Rules, v1.3        263FACT MODELS
concept  is closed in  
conceptual schema
conceptual schema
conceptual schema  
includes concept
conceptual schema  
includes fact model
fact model  includes fact
fact model  is based on 
conceptual schema
verb concept  is internally 
closed in conceptual  
schema
264                 Semantics of Business Vocabulary and Business Rules, v1.3
Semantics of Business Vocabula ry and Business Rules, v1.3        26525 Supporting Documents
25.1 General
Several XML documents are derived from th is document, particularly for the following vocabularies specified in Clauses 7 
through 21.  Each of these has a na mespace URI specified in Clause 7.
SBVR Vocabulary
The content of each of the documents li sted in this clause is normative.
25.2 SBVR XMI Metamodel
The MOF-based metamodel package shown in 23.3.1 is seriali zed, with all merging of packages performed, as an XML 
document.  The URL of each document is  constructed by adding ”-XMI-Metamodel”  in front of th e “.xml” in the 
corresponding namespace URI.  The document’s URL is listed here:
http://www.omg.org/spec/SBVR/20141201/SBVR-XMI-Metamodel.xml
25.3 SBVR XMI Metamodel XML Schema
An XML Schema is created based on the XMI 2.1 specification from each of the MOF-based me tamodel packages listed in 
25.2. SBVR tools generate and process SBVR Content Model ex change documents that validate according to the SBVR XML 
Schema files described here. The URL of each document is constructe d by putting “.xsd” in place of “.xml” in the 
corresponding namespace URI.  The schema’s URL is listed here:
http://www.omg.org/spec/SBVR/20141201/SBVR-XML-Schema.xsd
25.4 SBVR Content Model for SBVR
For each of clauses 7 through 21, all vocab ulary entries and rules are described in  terms of the SBVR XMI Metamodel (see 
sub clause 25.2) and are serialized as XML documents base d on the SBVR XMI Metamodel XML Schema (see sub clause 
25.3).  This document is an XML serialization of SBVR in  terms of itself.  The document’s URL is listed here:
http://www.omg.org/spec/SBVR/20141 201/SBVR-Content-Model-for-SBVR.xml
In each of the XML documents, an  xmi:id used for a designation in a vocabular y namespace is constructe d from the signifier 
of the designation by upcasing each character  that follows a blank and th en removing the blanks.  Si milarly, an xmi:id for a 
verb concept wording is constructed from the expression of the verb concept word ing by removing subscripts, upcasing each 
character that follows a blank and then rem oving the blanks.  This allows any of these designations and verb concept wordings 
described by one of the documents to be referenced using a URI which appends a “#” and an xmi:id to the document’s URL.  For example, a URI fo r ‘noun concept’ is
http://www.omg.org/spec/SBVR/20141201/SB VR-Content-Model-for -SBVR.xml#nounConcept
266                 Semantics of Business Vocabulary and Business Rules, v1.3
Semantics of Business Vocabulary a nd Business Rules, v1.3        267Part IV - Annexes
This part contains th e annexes, including:
A- SBVR Structured EnglishB- SBVR Structured English PatternsC- Use of UML Notation in a Business Cont ext to Represent SBVR-style V ocabularies
D- Additional References
268  Semantics of Business Vocabula ry and Business Rules, v1.3
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      269Annex A - SBVR Structured English
(informative)
A.1 General
The most common means of expressing definitions and business rules is through statements, not diagrams.  While diagrams 
are helpful for seeing how concep ts are related, they are impractical as a primary means of defi ning vocabularies and 
expressing business rules.
This specification defines an English vocabul ary for describing vocabularies and stating rules.  There are many different ways 
that this vocabulary and other English vocabularies described using SBVR can be combined with common English words and 
structures to express definition s and statements.  However expressed, the seman tics of definitions and rules can be formally 
represented in terms of the SBVR vocabulary and, particularly, in terms of logical formulations (the SBVR conceptualization 
of formal logic).
This annex describes one such way of using English that maps mech anically to SBVR concepts.  It  is not meant to offer all of 
the variety of common English, but rather, it uses a small number of English structur es and common words to provide a simple 
and straightforward mapping.
All formal definitions and rules in this document that are pa rt of ‘SBVR in terms of itse lf’ are stated using the SBVR 
Structured English. These statements can then be interpreted automatically  in order to create MOF and/or XMI 
representations.
The description of the SBVR Structured English is divided into sub clauses.
• Expressions in SBVR Structured English
• Describing a V ocabulary
• V ocabulary Entries
• Specifying a Rule Set
• Guidance Entries
A.2 Expressions in SBVR  Structured English 
This document contains numerous statements and definitions that represent corresponding logical formulations.  These 
statements are recognized by being fully expressed using the font s listed below.  Note that these fonts are also used for 
individual designations in the context of ordinary, unformalized st atements in order to note th at defined concepts are being 
used.
There are four font styl es with formal meaning:
term The ‘term’ font is used for a designation for a noun concept (other than an individual noun concept), one that 
is part of a vocabulary being used or defined (e.g., modal formulation , verb concept ). This style is applied 
to the designation where it is defined and wherever it is used.
Terms are usually defined using lower case letters unle ss they include a proper noun. Terms are defined in 
singular form.  Plural forms ar e implicitly available for use.
270                                                                                                     Semantics of Business Voca bulary and Business Rules, v1.3Name The ‘name’ font is used for a design ation of an individual noun concept — a name.  Names tend to be proper 
nouns (e.g., California ).  This style is applied to a name where it is defined and wherever it is used.  Note that 
names of numerical values in formal statements are also shown in this style (e.g., 25).  See the definition of 
‘name ’ for more details.
Names appear using appropriate capit alization, which is usually the first letter of each word, but not 
necessarily.
verb The ‘verb’ font is used for designations for verb concepts — usually a verb, preposition, or combination 
thereof.  Such a designation is defined in the context of a verb concept wording.  This font is used both in the context of showing a verb concept wording (e.g.,  
‘reference scheme
 is for  concept ’) 
and in the context of usi ng it in a statement (e.g.,  
“Each  reference scheme  is for  at least one  concept .”) 
See the definition of ‘verb concept wording ’ in Part II for more details.
Verb concept wordings shown as vo cabulary entries use sing ular, active forms of verbs with the exception 
that present participles are sometimes  used for characteristics. Infinitive , subjunctive, passive, and plural 
forms of verbs are implicitly usable in statements and definitions. For a binary verb concep t, the implicit 
passive form of a verb uses the past par ticiple of the verb preceded by the word “ is” and followed by the 
preposition “ by.”  For example, the im plicit passive form of ‘expression  represents  meaning ’ is 
‘meaning  is represented by  expression ’.  The same pattern holds for verb concepts with more than two 
roles where a verb is used between the first two placeholders.  For exampl e, the implicit passive form of 
‘thing  fills role in actuality ’ is ‘role is filled by  thing  in actuality ’.  Note that there is no inverse implication 
of an active form from a passive form.
keyword The ‘keyword’ font is used for linguistic symbols used  to construct statements – the words that can be 
combined with other designations to form statements and definitions (e.g., ‘ each ’ and ‘ it is obligatory 
that’).  Key words and phrases are listed below.
Quotation marks are also in th e ‘keyword’ font.  The text within quotes is in ordinary font if the meaning of 
the quotation is uninterpreted text.  The text within quot es is in styled text if the meaning of the quotation is 
formally represented.  Single quotation marks are used  to quote a designation or verb concept wording that 
is being mentioned. If a designation is mentioned (where the designation is itself th e subject of a statement) 
it appears within single quote marks (e.g., ‘actuality ’ and ‘California ’ used to talk about those designations).  
Single quotes are also used around a verb con cept wording that is being mentioned (e.g., ’reference  
scheme  is for  concept ’ used to talk about that verb concept word ing).  Double quotation marks are used in 
other cases, such as to quote a statement.
Single quotation marks are also used to mention a concept – to refer to the concept itself rather than to the 
things it denotes.  In this case, a quoted designation or verb con cept wording is pr eceded by the word 
‘concept ’ or by a term for a kind of conc ept. For example, the statement,  
“The concept  ‘quantification ’ is a category  of the concept  ‘logical formulation ’”  
refers to the named concepts, not to quantifications and logical formulations.  A role can be named with respect to a verb concept in this same way (e.g.,  
“the role
 ‘meaning ’ of the verb concept  ‘expression  represents  meaning ’”).
Periods also appear in the ‘keyword’ font. A period is used to terminate a statement, but not a definition.  
Other punctuation symbols (e.g., parentheses, comma) al so apply the ‘keyword’ font  when part of a formal 
expression.
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      271A.2.1 Key words and phrases for logical formulations
Key words and phrases are shown below for expressi ng each kind of logical form ulation. The letters ‘ n’ and ‘ m’ represent use 
of a literal whole number.  The letters ‘ p’ and ‘ q’ represent expressions of propositions. 
A.2.1.1 Quantification
each universal quantification
some  existential qu antification
at least one  existential qu antification
at least n at-least-n quantification
at most one  at-most-one quantification
at most n at-most-n quantification
exactly one  exactly-one quantification
exactly n exactly-n quantification
at least n and at most m numeric range quantification
more than one  at-least-n quantification  with n = 2
A.2.1.2 Logical Operations
it is not the case that  p logical negation
p and  q conjunction
p or q disjunction
p or q but not both exclusive disjunction
if p then  q implication
q if p implication
p if and only if  q equivalence  (see exception explained under Modal Operations below)
not both p and  q nand formulation
neither p nor q nor formulation
p whether or not  q whether-or-not formulation
Where a subject is repeated when using ‘ and’ or ‘or’ the repeated subject can be elided .  For example, th e statement, “An 
implication has an antecedent and the implication is embedded in a modal formulation,” can be abbreviated to this:  “An 
implication has an antecedent and is embedded in a modal formulation.”  Similarl y, a repeated subject and verb can be elided.  
For example, the statement, “A n implication has an antecedent and the implication has a consequent,” can be abbreviated to 
this:  “An imp lication has an antecedent and a consequent.”
The keyword ‘ not’ is used within an expression after the verb “ is” as a way of introducing a logical negation . Also, the  
keywords “ does not ” are used before other verbs (modified to be infinitive) to introduce a logical negation .
272                                                                                                     Semantics of Business Voca bulary and Business Rules, v1.3A.2.1.3 Modal Operations
it is obligatory that  p obligation formulation
it is prohibited that  p obligation formulation  embedding a  logical negation
it is necessary that  p necessity formulation
it is impossible that  p necessity formulation  embedding a  logical negation
it is possible that  p possibility formulation
it is permitted that  p permissibility formulation
The following key words are used within expressions having a verb to form verb complexes that add a modal operation.
… must … obligation formulation
… must not … obligation formulation  embedding a  logical negation
… always … necessity formulation
… never … necessity formulation  embedding a  logical negation
… may … permissibility formulation
The key word phrase “ only if ” is used in combination with some of the key words and phrases shown above to invert a 
modality.
… may … only if  p is equivalent to     … must not … if not  p
it is permitted that  q only if  pis equivalent to     it is obligatory that not q if not  p
it is possible that  q only if  pis equivalent to     it is necessary that not q if not  p
For example, the following two st atements have the same meaning.
A car may  be rented only if  the car is available.
A car must not  be rented if the car is not available.
The key word “ only” can also be used before a preposition in combination with “ may ” to invert a modality. The noun phrase 
after the preposition is then understood as a negated re striction as shown in these two equivalent statements: 
A car may  be rented only to a licensed driver.
A car must not  be rented to a person that is not a licensed driver. 
Because of the use of “ only” in stating modal operations, the pattern “ p if and only if  q” for equivalence  is not used if p 
involves a modal operation. 
A.2.2 Other Keywords
the 1.  used with a designation to make a pronominal reference to a previous use of the same designation.   
     This is formally a binding to a variable of a quantification.
2.  introduction of a name of an indivi dual thing or of a definite description
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      273a, an universal or existential quantification, depending on context based on English rules
another  (used with a term that has been pr eviously used in the same statement) existential quantification plus a 
condition that the referent thing is not the same th ing as the referent of the previous use of the term
a given  universal quantification pushed outs ide of a logical formulation where ‘ a given ’ is used such that it 
represents one thing at a time – this is used to avoid ambiguity where the ‘ a’ by itself could otherwise be 
interpreted as an existential quantification. Within a definition, ‘ a given ’ introduces an auxiliary variable 
into the closed projection that  formalizes the definition. 
that 1.  when preceding a designation for a noun concept, this is a binding to a variable (as with ‘ the’).
2.  when after a designation for a noun  concept and before a designation fo r a verb concept, this is used to  
     introduce a restriction on things denoted by the previous designation based on facts about them.
3.  when followed by a propositional statement, this is  used to introduce a nominalization of the proposition  
     or an objectification, depending on whether the e xpected result is a proposition or a state of affairs.   
     See A.2.5.
who the same as the second use of  ‘that’ but used for a person
is of The common preposition “ of” is used as a shorthand for “ that is of.”  For any sentential form that takes the 
general form of ‘ <placeholder 1>  has <placeholder 2> ’ there is an implicit reversed form of 
‘<placeholder 2>  is of <placeholder 1> ’ that has the same meaning.
what  used to introduce a variable in a pr ojection as well as indicate that a pr ojection is being formulated to be 
considered by a question or answer  nominalization.  See A.2.5 below.
A.2.3 Examples
The example above includes three key words or phrases, two desi gnations for noun concepts and one for a verb concept (from 
a verb concept wording) , as illustrated below.
Below are two statements of a single rule:
1. A rental must have at most three additional drivers.2. It is obligatory that each rental has at most three additional drivers.
Using the font styles of SBVR Structur ed English, these rule statements are:
1.A rental
 must have  at most three additional drivers .
It is obligatory that each  rental car  is owned by exactly one branch .
274                                                                                                     Semantics of Business Voca bulary and Business Rules, v1.32.It is obligatory that each rental  has at most three additional drivers .
A semantic formulation of the rule can be seen in the introduction to Clause 21.The characteristic ‘driver
 is of age ’ has the following definition: “the age of the driver is at least the EU-Rent Minimum 
Driving Age.”  Below is the definition using the SBVR Structured English styles.
Definition:     the age of the driver  is at least  the EU-Rent Minimum Driving Age
A semantic formulation of the definition can be seen in the introduction to Clause 21.
A.2.4 Qualifying Signifiers by Vocabulary and/or Subject Field
Some signifiers are used to mean differen t things in different vocabularies or in different contexts. In SBVR structured Englis h 
a signifier can be followed by parentheses enclosing the name of a vocabulary and/or a subject field. If both are present, they  
are separated by a comma. Qualifications  are shown in the example rules below.
Necessity: Each customer  (car rental responsibility ) is a corporate renter  or is an individual  
customer .
The signifier “customer” is used in two ways in the EU-Rent English Vocabulary .  So the first rule above uses “customer” for its 
meaning in the subject field ‘ car rental responsibility ’.
If the same rule is stated in a place where the EU-Rent English Vocabulary  is not understood to be in use, the rule would be 
stated as follows in order to fully qualify its terms:
Necessity: Each customer  (EU-Rent English Vocabulary , car re ntal responsibility ) is a corporate renter  
(EU-Rent English Vocabulary ) or is an individual customer  (EU-Rent English Vocabulary ).
A.2.5 Objectification and Nominalization
The keyword ‘ that’ can introduce a propositional expressi on for either of two kinds of logical formulations: objectification 
and proposition nominalization. The follow ing examples use the verb concepts ‘ car is assigned to rental , ‘car assignment  
involves  car’, ‘car assignment  is to rental ’, ‘rental  has pick-up date ’, and ‘ rental  is guaranteed by  credit card ’. 
The first example is a structural rule st atement whose logical formula tion includes an objectifi cation. It states that a car 
assignment  is an actuality denoted by the proposition that a given car is assigned to a given rental. Note that only the third use 
of ‘that’ in the example below introdu ces an objectification. The ot hers introduce restrictions
Necessity: A car assignment  that involves  a car and that is to a rental  is an actuality  that the  
car is assigned to the rental .
An objectification uses a propositional expression to identify a st ate of affairs or event. States and events can then be relat ed to 
times and durations or be involved in any number of verb c oncepts that concern states or events. Consider the following 
examples of verb concepts. 
state of affairs  occurs before point in time
state of affairs1 occurs before state of affairs2 occurs
The following rule uses the first verb concept above:
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      275A car assignment  that is to a rental  must occur before  the pick-up date  of the rental .
SBVR Structured English supports formulating an objectificatio n using a convenient mechanism that is based on the word 
“occurs ” being in the designation of a verb c oncept after a placeholder. An implicit fo rm of the verb con cept leaves out the 
word “ occurs ” after the placeholder and takes a propos itional expression rather than a no un expression in the position of the 
placeholder. In other words, the rule  above can be stated like this:  
A car must be assigned to  a rental  before  the pick-up date  of the rental .
These implicit forms enable objectifying directly within a statem ent without separately defining a verb concept objectification  
for each verb concept whose instances might be objectified. Fo r example, using the second ve rb concept listed above the 
following rule can be formed even though no general concept is define d to objectify the verb concept ‘ rental  is guaranteed 
by credit card ’.
A rental  must be guaranteed by  a credit card  before  a car is assigned to  the rental .
The next example is a proposition nominalization. It uses the additional verb concepts ‘ report  specifies  fact’ and ‘ rental  has 
rental report ’.  The keyword ‘ that’ nominalizes a fact to be specified.
If a car is assigned to  a rental  then the rental report  of the rental  must specify  that the car is assigned to  
the rental .
The next example is an answer nominalization. The keyword ‘ what ’ is used to put variables in a projection.
The rental report  of each  rental  must specify  what car is assigned to  the rental .
An expression of a statemen t can include the keyword ‘ what ’ multiple times, putting more variables in the projection (for 
example, “ what car is assigned to  what rental ”).  A question nominalization is form ed in the same way as an answer 
nominalization, but nominalizes the questio n itself rather than an answer to it.
A.2.6 Intensional Roles
Some verb concepts about time  and change have what can be called intensional roles. Each intensional role ranges over a 
concept type. In English, most verbs ar e about their expressed subjects and objects, but in some cases, a verb involves the 
meaning of the expression of the subject or object. The verb takes its argument by name rather than by value. Verb concepts for  
such verbs are often about time and change.  
The SBVR Structured English uses a special  syntactic clue to identify placeholders  for intensional roles in verb concept 
wordings. A placeholder that ends with an asterisk is taken to  indicate that a n oun concept nominalization is used in the 
formulations of uses of the verb concept wording so that rather  than binding to what is directly denoted by an expression, the 
role binds to the concept of what is expr essed. The asterisk is part of the placehol der. An example of a logical formulation 
based on the first verb concept below is in the description of noun concept nominalization  in Clause 21.  Note that the 
examples below are not part of the normative SBVR vocabularies.
unitary noun concept * changes
Definition: one thing replaces another thing as being the instance of the unitary noun concept
Example: “The scheduled pick-up time of an advance re ntal can change”.
Example: For every rental, the pick-up location of th e rental cannot change.
276                                                                                                     Semantics of Business Voca bulary and Business Rules, v1.3unitary noun concept * changes to thing  
Definition: the thing  replaces another thing as being the instance of the unitary noun concept
Example: “The return branch of a rental changes to the Heathr ow Airport branch”.
unitary quantity concept
Definition: unitary noun concept  that incorporates the character istic of being a quantity
unitary quantity concept * increases by quantity  
Definition: a quantity equal to an initial quantity plus the quantity  replaces the initial quantity as being the 
instance of the unitary quantity concept
Example: “EU-Rent’s headcount increases by 300”.  
Suppose EU-Rent’s headcount has been 500. In the formulation of the statement, the 
‘unitary quantity concept *’ role binds to a general concept defined as EU-Rent’s headcount.  
It does not bind to 500, which has been the instance of that general concept.  The ‘ quantity ’ 
role binds to the quantity 300.  The conclusion is that the quantity 800 replaces 500 as EU-Rent’s headcount. In contrast, suppose the stat ement were formulated using a different verb 
concept, ‘ quantity
1 increases by quantity2,’ which does not use an intensional role. The 
‘quantity1’ role would bind to 500 leading to the conclusion that 500 increases by 300, which 
is nonsense because 500 will always be 500.
A.3 Describing a Vocabulary
A vocabulary is described in a document sub clause having glos sary-like entries for concepts having representations in the 
vocabulary.  Those entries are explained in the next sub cl ause. The introduction to a vocabulary description includes the 
vocabulary’s name and can further include any of the several kinds of details shown in the skeleton below.
<Vocabulary Name>
Description:
Source:Speech Community:Language:Included Vocabulary:Note:
A.3.1 The Vocabulary Name
The vocabulary name appear s in the ‘Name’ Font.
A.3.2 Description
The ‘Description’ caption is used to intr oduce the scope and purpose of the vocabulary.
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      277A.3.3 Source
The ‘Source’ caption is used if the vocabulary being described is based on a formally-defined work.  For example, if the 
vocabulary being described is based on a glossary or other do cument developed independently of the formalisms of SBVR, 
then that glossary or other document is shown as the source.
A.3.4 Speech Community
The ‘Speech Community’ caption is used to  name the speech community that controls  and is responsible for the vocabulary.
A.3.5 Language
The ‘Language’ caption is used to name  the language that is the basis of the vocabulary.  Language names are from ISO 639-2 
(English) .  By default, English  is assumed.  Note that the SBVR Structured English is based only on English, so descriptions, 
definitions, and other details are in English but represen tations being defined can be in another language.    
EU-Rent Vocabulaire Française
Language: French
A.3.6 Included Vocabulary
The ‘Included V ocabulary’ caption is used to  indicate that another vocabulary is fully  incorporated into the vocabulary being 
described.  All designations and verb concept wordings of an  included vocabulary are part of the vocabulary being described.
A.3.7 Note
The ‘Note’ caption labels explanatory notes that do not go under the other captions.
A.4 Vocabulary Entries
Each entry is for a single concept, called the entry concept. It starts  with a primary representation which is either a designa tion 
or a verb concept wording for the concept.
Any of several kinds of captioned details can be listed under th e primary representation.  A skel eton of a vocabulary entry is 
shown below followed by an expl anation of the use of each caption.
<primary representation >
Definition:
Source:
Dictionary Basis:
General Concept:Concept Type:
Necessity:
Possibility:Reference Scheme:
Note:
Example:
278                                                                                                     Semantics of Business Voca bulary and Business Rules, v1.3Synonym:
Synonymous Form:
See:
Subject Field:Namespace URI:
A.4.1 Designation or Verb Concept Wording
A primary representation of an entry can be a term, a name, or a verb concept wording. It is shown in its appropriate font styl e. 
The primary representation for a general concept is a term th at is a designation of the general concept. The primary 
representation for an individual noun concept is a name that is a designa tion of the individual noun concept. 
The primary representation for a verb concept is a verb concep t wording. The expression of a placeholder is generally the 
underlined signifier of a designation used by the placeholder to  indicate that expressions subs tituted for the placeholder are 
understood to denote instances of the designated concept. A designation used by a placeholder for a verb concept role is a 
designation of a general concept that the verb concept role ranges over. That general concept can be a situational role. 
Sometimes the designation of the general concept has the same si gnifier as a designation of th e verb concept role. In the 
unusual verb concept wording where multiple placeholders use the same desi gnation, the expression of a placeholder can 
include a subscript to make the expressions of placeholders distinct  within the verb concept wordin g.  Subscripts also help to 
correlate placeholders across synonymous forms as shown in the example below.
concept1 specializes concept2
Definition: the concept1 incorporates each character istic incorporated into the concept2 plus at least one 
differentiator
Synonymous Form: concept2 generalizes  concept1
Synonymous Form: concept1 has more general concept2
Synonymous Form: concept2 has category1
The verb concept wordings in the example above represent one verb concept th at has two verb concept roles.  From the 
primary entry it is seen that each of the verb concept roles rang es over the concept ‘concept ’.  From the second synonymous 
form, it is seen that the second verb concept role more specifically ranges over the general concept ‘more general concept ’ 
(which is a situational role).  From the third synonymous form, it  is seen that the first verb concept role more specifically 
ranges over the general concept ‘category ’ (which is also a situational role).
Note :  The primary representation for a verb co ncept is a verb concept wording rather than a designation b ecause designations 
of verb concepts typically have nonunique signifiers (e.g., “has”).
The primary representation, whether a de signation or verb concep t wording, is in the vo cabulary namespace for the 
vocabulary.  Also, if a verb concept wording is of the pa ttern “<placeholder 1> has <place holder 2>”, the expression of 
<placeholder 2>, less any subscript, is ta ken as the signifier of a designation of th e second verb concept role. That designati on 
is in an attributive namespace for the subject concept represented by the design ation used for <placeholder 1>. Having a 
designation for the second verb concept role in an attri butive namespace means that the designation is recognized as 
representing the role when it is used in the context of being attributed  to instances of the subject  concept. From the example 
above two designations of verb concept roles are found in an attributive namespace having the subject concept ‘concept ’. 
These designations have the signifiers “ more general concept ” and “ category .” Although these designations have the same 
signifiers as designations of the general concepts  ‘more general concept ’ and ‘category ’, they are different designations. 
They are within the attributive namespace a nd represent different concepts (the verb concept roles, not the general concepts). 
See examples in sub clause 19.5.3 under ‘attributive namespace ’.  Also, if a verb concep t wording is for a unary 
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      279characteristic, a designation is in an a ttributive namespace for the concept represen ted by the designation used for the verb 
concept wording’s placeholder.
It is recommended that quantifiers (incl uding articles) and logical operators not be embedded within designations and verb 
concept wordings.
A.4.2 Definition
A definition is shown as an expression that  can be logically substituted for the primary representation. It is not a sentence, so it 
does not end in a period.
A definition can be fully formal, partly formal or informal. It is  fully formal if all of it is styled as described above.  A p artially-
formal definition starts with a styled designation for a more general concept but other details depend on external concepts.
Styles of definition are explained separately for different types of concepts.
A.4.2.1 Definition of a General Concept
A common pattern of definition begins with a designatio n for a more general concept followed by the keyword ‘ that’ (used in 
the second sense defined for ‘ that’ in the Other Keywords sub clause above) and then an expression of necessary and sufficient 
characteristics that distinguish a thing of the defined concept from other things of the more general concept. Another less use d 
pattern also leads with a designation for a mo re general concept but then uses the word ‘ of’ with another expression as 
explained in the Other Ke ywords sub clause above.
Two kinds of information are formally expressed by a fully formal definition.
1. A fact that the concept bein g defined is a category of a particular more general concept
2. A closed projection that defines the concept.
Only the first kind of information is formally expressed by a pa rtially formal definition.  A partially formal definition leads  
with a styled designation that is for a more general concep t.  That designation is generally followed by the keyword ‘ that’ and 
then an informal expression of neces sary and sufficient characteristics.
The following example shows a partially formal definition.   It formally expresses the fact that the concept  ‘icon’ is a category 
of the concept ‘nonverbal designation ’, but it uses words that are external to the formally available vocabulary.
icon
Definition: nonverbal d esignation  that is a pictorial representation
The next example is fully formal.  Its form al interpretation includes that the concept ‘representation ’ specializes the concept  
‘actuality ‘ and includes a closed projection co nveying semantics of the definition.
representation
Definition: actuality  that a given  expression  represents  a given  meaning
The next example is not formal at all.  It defines the most general concept used by SBVR.
thing
Definition: anything perceivable or conceivable
280                                                                                                     Semantics of Business Voca bulary and Business Rules, v1.3A definition of a general concept can generally be read as a statement using the following patt ern (where “a” represents either  
“a” or “an”):
A <designation> is a <definition>.
For example:  An icon is a nonverbal desi gnation that is a pictorial representation.
Another style of formal definition is extensional.  It uses disjunction to combine a number of concepts.  For example, a 
contextualized concept is anythi ng that is a role or a facet. 
contextualized concept
Definition: role or facet
A semantic formulation of the extensional definition above is  the same as for the logical ly equivalent definition, “ thing  that  is 
a role or that is a facet .”
A.4.2.2 Definition of an Individual Noun Concept
A definition of an individual noun concept must be a definite description of one single thing.  It can start with a definite ar ticle 
(e.g., “ the”).  It can generally be read as a statement using the following pattern. The leading “The” is optionally used 
depending on the designation.
 [The] <designation> is <definition>.
It is often the case that an individual noun concept has no definition because it is widely unders tood.  In such a case the 
‘General Concept’ caption can be us ed to state the type of the name d thing.  Here is an example.
Switzerland
General Concept: country
A.4.2.3 Definition of a Verb Concept
A definition given for a verb concept is an  expression that can be subs tituted for a simple statem ent expressed using a verb 
concept wording of the verb concept.
The definition must refer to the placeholders in the verb concept wording. This is done in order to relate the definition to th e 
things that play a role in in stances of the verb concept. Whether or not the definition is formal, eac h reference to a placehol der 
appears in the ‘term’ font and is preceded by the definite article, “ the”.
Here is an informal example followed by a fully-formal one.
statement  expresses proposition
Definition: the proposition  is what is meant by the statement
sequence  is of  general concept
Definition: each thing  that is included in  the sequence  is an instance  of the general concept
The second definition above is formal such th at it translates to  a closed projection.
A definition of a verb concept can generally be read using the pattern below, which is shown for a binary verb concept but 
works for verb con cepts of any arity (“a” repr esents either “a” or “an”).
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      281A fact that a given <placeholder 1> <v erb concept designation> a given <placeholder 2> is a fact that <definition>.
For example:  A fact that a given statement expresses a given proposition is a fact that the proposition is what is meant by th e 
statement.
Similarly, the equivalence understood from a definition of a ve rb concept can generally be read using the following pattern:
A <placeholder 1> <verb concept designation> a <placeholder 2> if and only if <definition>.
For example:  A statement expresses a proposition if and only if the proposition is what is meant by the statement.
A.4.3 Source
The ‘Source’ caption is used to indicate a so urce vocabulary or docu ment for a concept. 
The source’s designation for the concept is given in square brack ets and quoted after the name of the source. It might or might  
not match the entry’s primary representation.  If the source has a name for the concept itself, the name is given in square 
brackets unquoted.  The designation from the sour ce is quoted if it is a term for the concept.
thing
Source: ISO 1087-1 (English)  (3.1.1) [‘object ’]
individual  noun concept
Source: ISO 1087-1 (English)  (3.2.2) [‘individual noun concept ’] 
The keywords “ based on ” indicate the definition of the concept is largely derived from the given source but had some 
modification, as in the following example.
language
Definition: system of arbitr ary signals (such as voice sounds or written symbols) and rules for combining 
them as used by a nation, people or other distinct community
Source: based on  AH
A.4.4 Dictionary Basis
This caption labels a definition from a common dictionary that  supports the use of the primar y representation.  The entry 
source reference (written in the ‘Source’ style described above) is  supplied at the end of the quoted definition.  A dictionary  
basis should not be interpreted as an adopted definition.
A.4.5 General Concept
The ‘General Concept’ caption can be used to  indicate a concept that generalizes the entr y concept.  This is not needed if ther e 
is a definition that starts with the general concept, but it is helpful in cases where a definiti on is not provided, such as is  often 
the case for individual noun concepts (n amed things) or concepts taken from  a source.  Here are two examples.
Switzerland
General Concept: country
282                                                                                                     Semantics of Business Voca bulary and Business Rules, v1.3individual noun concept
Source: ISO 1087-1 (English)  (3.2.2) [‘individual noun concept ’]
General Concept: concept
A.4.6 Concept Type
The ‘Concept Type’ caption is used to specify  a type of the entry concep t. This is typically not used if the concept has no 
particular type other than what is obvious from the primary representation.
• A name is implicitly for an individual noun concept .
• Any term is implicitly for a general concept .
• A verb concept wording is implicitly for a verb concept .
• For a verb concept wordi ng, one placeholder implies a characteristic  and two placeholders imply a binary verb  
concept .  For example, ‘ variable  has type ’ is implicitly for a binary verb concept .
• Where a definition formally gives a more general concept, the concept being defined specializes that more general 
concept.
If more than one concept type is mentioned, then they are separated by commas. Order is insignificant.
The concept type  ‘role’ is commonly used where the pr imary entry is a term.  The exam ple below shows that the concept 
‘logical operand ’ is a role that is played by a logical formulation. Since the entry concept of a term is implicitly a general  
concept , the additional indication that it is a role implies that it is, by definition, a situational role . 
logical operand
Concept Type: role
Definition: logical formulation  upon which a given  logical operation  operates
Any general concept  that specializes the concept ‘concept ’ can be given as a concept type.  The concept ‘obligation  
formulation ’ is a logical formulation kind, which is defined below. 
logical formulation kind
Definition: concept  that specializes  the concept  ‘logical formulation ’ and that  classifies a logical  
formulation  based on the presence or absence of a main logical operation or quantification
obligation formulation
Concept Type: logical formulation kind
A.4.7 Necessity and Possibility
A ‘Necessity’ or ‘Possibility’ is usually supplemental to a defin ition.  A ‘Necessity’ caption is used to state something that is 
necessarily true.  A ‘Possibility’ caption explains that somethin g is a possibility that is not prevented by definition.  See t he 
vocabulary entries in Clauses 8 through 21 for ‘structural business rule statement’ and ‘unrestricted business rule possibility  
statement’ (respectivel y) for more details.
The key phrase “ it is necessary that ” can be omitted from a statement of a struct ural rule captioned “Necessity” because it is 
implied by the caption.  Here ar e examples -- two necessity cl aims and one possibility claim.
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      283representation
Necessity: Each  representation  has exactly one  expression .
Necessity: Each  representation  represents  exactly one meaning .
vocabulary namespace  maps to package
Possibility: A vocabulary namespace  maps to more than one package .
Definitions express character istics that are necessary and sufficient to dist inguish things denoted by  a concept.  Sometimes 
there are necessities beyond what is sufficient.  The ‘N ecessity’ caption is used to  state such necessities.
A.4.8 Reference Scheme
The ‘Reference Scheme’ caption is used to state how things deno ted by the term can be distingui shed from each other based on 
one or more facts about the things. A refere nce scheme is expressed by referring to at least one role of a binary verb concept 
and indicating whether a reference involves a single instance of the role or whether it involves the extension of related 
instances.
An article (‘ a’, ‘an’, or ‘ the’) indicates a simple use of a role in which a singl e instance is used in a re ference.  The definite 
article ‘ the’ is only appropriate where ther e can be at most one instan ce of the role.  The words ‘ the set of ’ indicate that the 
extension is used.  The word ‘and’ is used to connect the expressions of use of multiple roles by a reference scheme. 
The following examples of reference scheme s are taken from the SBVR V ocabularies.  The first one below uses a single value 
of the ‘ closed logical formulation ’ role of the verb concept ‘ closed logical formulation  means  proposition ’ meaning that 
a proposition can be identified by any closed logical formulation whose meaning is the proposition. The second uses two verb 
concept roles. It uses a de finite article because each role binding  has exactly one bindable target  and is for exactly one  
verb concept  role .
proposition
Reference Scheme: a closed logical formulation  that means  the proposition
role binding
Reference Scheme: the bindable target  that is referenced by  the role bin ding and the verb concept role  that 
has the role binding
The reference scheme for the concept of referen ce scheme itself uses three roles extensionally.
reference scheme
Reference Scheme: the set of verb concept roles  that are simply used by the reference scheme  and the set 
of verb concept  roles  that are extensionally used by the reference scheme  and the set 
of characteristics  that are used by  the reference scheme
A.4.9 Note
A ‘Note’ caption is used to label explanatory notes that do not fit within the other captions.
A.4.10 Example
The ‘Example’ caption labels exam ples involving the entry concept.
284                                                                                                     Semantics of Business Voca bulary and Business Rules, v1.3A.4.11 Synonym
A synonym is another designation that can be substituted for the primary representation. It is a designation for the same 
concept. If the primary representation is a verb concept wordin g, then the ‘Synonymous Form’ caption is used rather than the 
‘Synonym’ caption.
The examples below show two synonyms for one concept having one definition. The preferred designation is given as the 
primary representation.
implication
Definition: logical formulation  that applies the logical “(MATERIALLY) IMPLIES” operation ( ) to an 
antecedent  and a consequent
Synonym: material implication
The meaning of two designations being synonyms is that they re present the same concept. Each synonym is in the vocabulary 
namespace of the vocabulary. 
A.4.12 Synonymous Form
A synonymous form is a verb concept wording for the same verb concept. The order of placehold ers for verb concept roles can 
be different.
A synonymous form can appear  elsewhere as its own entry.  However, this is  not typically done if the synonymous form is 
simply a passive form of the primary representation.  The foll owing example shows a synonymous form that reverses the order 
of verb concept roles.  Because the synonym ous form is simply a passive form of the primary representation, it does not appear 
as a separate entry.
statement  expresses proposition
Definition: the proposition  is what is meant by the statement
Synonymous Form: proposition  is expressed by statement
A synonymous form does not necessa rily use the same designations for all placehol ders as are used in the primary designation. 
One placeholder can use a different designation. The ones usi ng the same designation as placeholders of the primary form 
represent the corresponding verb concept roles, and the one placeholder that does not match represents the remaining verb 
concept role. The example below shows two entries, both for th e same concept.  One is expressed in terms of a role ( instance ) 
and the other is not.
concept  corresponds to  thing
Definition: the thing  is in the extension of the concept
Synonymous Form: concept  has instance
concept  has  instance
Synonymous Form: concept  corresponds to  thing
If the same term is used for multiple placeholders, then subscripts can be used to distinguish them.
thing1 is thing2
Synonymous Form: thing1 equals  thing2
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      285The meaning of two verb concept wordings being synonymous is that the two represent th e same verb concept. Each 
synonymous form is in  the vocabulary namespace of the vo cabulary. Designations are in a ttributive namespaces as explained 
for primary entries in A.4.1.
A.4.13 See
Where the primary representation  is not a preferred representation for the entr y concept, the “See:” caption introduces the 
preferred representation.  No definition is given in this case.
A.4.14 Subject Field
Where a signifier is not unique in a vocabul ary, there is a need for qu alification by a subject field.   The subject field of a 
designation is given using the “Subject Field” caption, as shown in the example below.
customer
Subject Field: Car Rental Responsibility
See: renter
customer
Subject Field: Vehicle Sales
Definition: person  who purchases a rental car  from EU-Rent at the end of its rental life
A.4.15 Namespace URI
If the primary entry is for a namespace, the  ‘Namespace URI’  caption is used to indicate a URI of the namespace. If the 
primary entry is for a vocabular y, the ‘Namespace URI’ caption is used to in dicate a URI of a vocabulary namespace for the 
vocabulary. Here is an example:
Meaning and Representation Vocabulary
General Concept: vocabulary
Namespace URI: http://www.omg.org/spec/SB VR/20070901/MeaningAndRepresentation
A.5 Specifying a Rule Set
SBVR Structured English uses the term ‘rule set’ to refer to any set of elements of guidance.  A rule set is specified in a 
document sub clause having several individual entries for guid ance. Those entries are explained in the next sub clause. The 
introduction to a rule set includes the rule set’s name and can further include any of the several kinds of details shown in th e 
skeleton below.
<Rule set name>
Description:
Vocabulary:Note:Source:
286                                                                                                     Semantics of Business Voca bulary and Business Rules, v1.3A.5.1 The Rule Set Name
The rule set name appears in the ‘name’ font.
A.5.2 Description
The ‘Description’ caption is used to de scribe the scope and purpose of the rules.
A.5.3 Vocabulary
The ‘V ocabulary’ caption is used to identi fy what vocabulary (defined in terms of SB VR) is used by statements in the rule set.
A.5.4 Source
The ‘Source’ caption is used if the rule se t is based on a separately-defined work.  It labels a reference to such a work, such  as 
a legal statute.
A.5.5 Note
The ‘Note’ caption is used to label explanatory notes that do not fit within the other captions.
A.6 Guidance Entries
Each entry in a rule set is an element of guidance -- expressed as  one of the following:
• An operative busines s rule statement
• A structural business rule statement
• A statement of advice of permission
• A statement of advice of possibility
Business rules include only those rules under business jurisdiction.  Entries can also be made for structural rules that are not  
under business jurisdiction.  Each entry includes the statement it self and optionally includes other information labeled by the  
captions shown below. 
<Guidance Statement>
Name:
Guidance Type:Description:Source:Synonymous Statement:Note:Example:Enforcement Level:
Use of each of the above captions is explained below.
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      287A.6.1 Guidance Statement
A guidance statement can be expresse d formally or informally.  A statement that is formal uses only formal ly styled text — all 
necessary vocabulary is available (by definition or adoption) such that no external concepts are required.  Such a statement ca n 
be formulated as a logical formulation.
A.6.2 Name
The ‘Name’ caption is used to specify a na me for the element of guidance.  The name  is then part of the formal vocabulary.
A.6.3 Guidance Type
The ‘Guidance Type’ caption is used to indicate the kind of element of guidance (i.e., one of the following):
• operative business rule
• structural business rule
• advice of permission
• advice of possibility
• advice of optionality
• advice of contingency
A.6.4 Description
The ‘Description’ caption is used to captu re the expression of the element of guid ance informally (as supplied by a business 
user).
A.6.5 Source
The ‘Source’ caption is used if the guid ance is from a separate source.  It  labels a reference to that source.
A.6.6 Synonymous Statement
The ‘Synonymous Statement’ caption is  used to state additional, equivalent statem ents of the guidance.  For example, a given 
rule can be expressed in a ‘prohibitive’ fo rm and also in an ‘obligator y’ form.  As for the primar y statement of the guidance, 
these additional statements can  be formal or informal.
A.6.7 Note
The ‘Note’ caption is used to label explanatory notes that do not fit within the other captions.
A.6.8 Example
The ‘Example’ caption labels examples of application of the el ement of guidance.
288                                                                                                     Semantics of Business Voca bulary and Business Rules, v1.3A.6.9 Enforcement Level
The ‘Enforcement Level’ caption labels the enforcement level that applies to  an operative business rule (only).
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      289Annex B - SBVR Structured English Patterns
(informative)
B.1 General
This annex contains material co mpiled to aid the interpretation of ‘SBVR in SB VR Structured English’ vocabulary entries, as 
documented in Annex A and applied in the text and diagram form s of Part II and Annex G. This  ‘language patterns’ material 
falls into two main categories:  
• reading SBVR V ocabulary designations
• reading verb concepts embedded in the definition text of SBVR V ocabulary designations.
A third sub clause contains the brief discussion of a useful pa ttern that, while not often applied in the text of Part II, is 
illustrated in Annex G (and, in particular, in the “10 Intr oductory Examples” given there and in the RuleSpeak and ORM 
Annexes).  This discussion introduces the use of a ‘short form’ verb concept that can be used to simplify the formulation and representation of vocabularies an d sets of elements of guidance.
When there is an associated way to depict  the construct in a graphic notation, a cross-reference is  provided, when applicable, 
to the ‘Use of UML Notation in a Business Context to Represent SBVR-based V ocabularies’ (Annex C) -- referred to here as 
the ‘UML style’ -- and to th e ‘Concept Diagram Graphic Notation (Annex I) ’ -- referred to here as the ‘CDG style’. 
B.2 Reading SBVR Vocabulary Designations
This sub clause presents the interpreta tion given to three kinds of designations:
• Terms
• Names
• Verb symbols
B.2.1 Primary Term for a General Concept
When I see a vocabulary entry as shown in  Figure B.1, I know to vocalize it as:
‘community’ is a term for a general concept.  And it is the ‘primary’ term used for the  
concept.
Figure B.1 - Recognizing an entry that is the primary term for a general concept
For how to depict this in graphics, see C.2 (UML style) and CDG style (sub clause I.2 in Annex I).

290                                                                                                    Semantics of Business Vocabu lary and Business Rules, v1.3Commentary:
This is a typical designation kind of entry presented as a ‘term’ -- the primary term for a general concept.  For this kind of 
entry, draw a labeled box.
It is possible to have additional terms for a given general con cept (i.e., terms that are synonyms).  Even when documented in 
the text form (using the ‘Synonym’ caption), the non-primary term s of a concept are not  typically reflected on the graphic.  
When it is considered useful to make e xplicit entries for the non-primary terms in  a presentation of th e vocabulary, the non-
primary terms can appear  using the ‘See’ caption to refer b ack to the concept’s primary term.
B.2.2   Primary Name for an Individual Noun Concept
When I see a vocabulary entry as shown in  Figure B.2, I know to vocalize it as:
‘Real-world numerical corresponde nce’ is a term that is a name for an individual noun  
 concept.  And it is the primary name used for the concept.
Figure B.2 - Recognizing an entry that is the primary name for an individual noun concept
For how to depict this in graphics, see C. 3 (UML style).  There is no specified way to  depict this in the CDG graphic notation.   
Commentary:This is a typical designation  kind of entry presented as a ‘name’ -- the primary name for an individual noun concept.  For this 
kind of entry, draw a labeled box, with the ‘name’ underlined.
It is possible to have additional names for a given individual  noun concept (i.e., names that  are synonyms).  Even when 
documented in the text form (using the ‘Synonym’ caption), the non-primary terms of a concept are not typically reflected on 
the graphic.  When it is considered useful to make explic it entries for the non-primary names in a presentation of the 
vocabulary, the non-primary names can a ppear using the ‘See’ captio n to refer back to the concept’s primary name.
B.2.3 Primary Reading (‘Sententi al Form’) for a Verb Concept
B.2.3.1 Primary Reading (‘Sentential Form’) for a Verb Concept -- Binary Verb Concept
When I see a vocabulary entry as shown in  Figure B.3, I know to vocalize it as:
There is a verb concept relating these two concepts and it uses the designation ‘shares 
understanding of’ when the concept terms are in this order.  Optionally, alternative readings can be provided using the ‘Synonymous Form’ caption (as illustrated at the bottom of Figure B.3).

Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      291Figure B.3- Recognizing an entry that is the primary reading for a binary verb concept
For how to depict this in graphics, see C.4.1 (UML style) and CDG style (sub clause I.4.1 in An nex I). There is a special case 
of depicting a binary verb concept that uses ‘has’ in the UML st yle.  For how to depict this in graphics, see C.4.2 (UML style) . 
There is no special way to depict this in the CDG graphic notation.  
Commentary:This is a typical sentential form  kind of entry for a verb concept --  in this case, a binary verb c oncept.  For this kind of entry, 
draw a labeled line between the boxes for the designations of the participating concepts. The reading is clockwise (when the 
tool does not provide a graphic symbol for indicating the directionality of the reading).
It is possible to have additional readings for a given verb co ncept (i.e., readings that are ‘s ynonymous forms’ of the verb 
concept).  Additional readings are optional in both the graphic and text forms. When defined in the text form, the ‘Synonymous Form’ caption is used.  Even when provided in the text, more than one reading is not typically reflected on the 
graphic.  However, having inverse readings on an association w ould be an extension to UML.  (This can be handled legally by 
defining a ‘UML profile’, which allows additional information and custom graphics in a model.)
An alternative graphic style is to apply th e n-ary graphic style (d escribed below) for all verb concepts, including binary.
B.2.3.2 Primary Reading (‘Sentential Form’) for a Verb Concept -- N-ary Verb Concept
When I see a vocabulary entry as shown in  Figure B.4, I know to vocalize it as:
There is a ternary verb concept relating these three concepts, using ‘i s replaced by ... in’ 
when the verb concept uses these term s for the concepts in this sequence.
Figure B.4 - Recognizing an entry that is the primary reading for an n-ary verb concept
For how to depict this in graphics, see C.4.3 (UML style) and CDG style (sub clause I.4.2 in Annex I).
Commentary:This is a sentential form  kind of entry for a verb concept -- in this case, an n-ary verb concept.   For this kind of entry, there are 
two diagrams forms.  The first diagram is the box-in-box style as  defined in Annex I, sub clause I.4.2.  The second diagram 
(UML-style) uses a box, given a stereotype  that names the category of verb concep t, and a label that reflects the primary 
reading for the verb concept. Th e concept terms are placed in [ ].

292                                                                                                    Semantics of Business Vocabu lary and Business Rules, v1.3Note-1:  The label in the UML form does not use the UM L association ‘name’; the UM L association ‘name’ is 
reserved for use as a ‘real’ name.
Note-2:  While suggestions have been given for depicting multiple readings on a diagram, showing additional 
readings for n-ary verb concepts  is not currently part of the scope of this documentation.
B.2.3.3  Primary Reading (‘Sentential Fo rm’) for a Verb Concep t -- Characteristic
When I see a vocabulary entry as shown in  Figure B.5, I know to vocalize it as:
There is a characteristic for this concept, with a designation of ‘is damaged’.
Figure B.5 - Recognizing an entry that is the primary reading for a characteristic
For how to depict this in graphics, see C.4.4 (UML style) and CDG style (sub clause I.4.3 in Annex I).
Commentary:This is a sentential form  kind of entry for a verb concept --  in this case, a characteristic. For th is kind of entry, the two graphic 
notations use different forms.  The first diagram above shows th e box-in-box style as defined in Annex I (sub clause I.4.3 in 
Annex I).  For the UML-style, three alternatives are offered:
1. List the designation inside the box (‘attribute’ style).2. Draw in the same style as fo r an n-ary verb concept (above).
3. Draw using the association ‘diamond’.
NOTE: The notation for characteristic woul d be an extension to UML, handled legally by defining a ‘UML profile’.
B.2.3.4 Two Vocabulary Entries (Sentential Form and Term) for a Concept
When I see a pair of vocabulary entries as shown in , I know to vocalize this case as:
These two entries are for coextensive concepts.  I understand that, even though these are 
two entries in the vocabulary, they have the same instances.  
Figure B.6- Recognizing a pair of entries (sentential form and term) for a concept
\rented car  is recovered from  non-EU-Rent site  to branch
car recovery
Definition: actuality  that a given  rented car  is recovered from  a given  non-EU-Rent site  to a given  
branch
For how to depict this in graphics, see C.9 (UML style) and CDG style (sub clause I.4.4 in Annex I).

Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      293B.3 Reading Embedded Connections
There are also connections that are specified when the SBVR Structured English language is used to compose the definition of 
a vocabulary entry. The material  in this sub clause documents the most comm on patterns used in writing vocabulary entry 
definitions using the elements of style defined in Annex C.
The following seven patterns have been documented.
• categorization
• is-role-of proposition
• is-facet-of proposition
• partitive verb concept
• classification (‘pred efined extension’)
• categorization type
• categorization scheme
B.3.1 Categorization
When I see this:
semantic community
Definition: community  whose unifying characteristic  is a shared under standing (perception) of the things 
that they have to deal with
I know this is shorthand for:
semantic community
Concept Type: category
Definition: community  whose unifying characteristic  is a shared under standing (perception) of the things 
that they have to deal with
I know to vocalize it as:
The concept ‘semantic community’ is a ‘category’  of the more general concept ‘community’.  
Furthermore, I know that what  distinguishes this particular  kind of community from the 
general case is that it is ... <distinctions brought out in the rest of the definition>
For how to depict this in graphics, see C.6 (UML st yle) and CDG style (sub clause I.3.1 in Annex I).
B.3.2 Is-role-of Proposition
When I see this:
renter
Concept Type: role  
Definition: driver  who ...
I know to vocalize it as:
294                                                                                                    Semantics of Business Vocabu lary and Business Rules, v1.3The concept ‘renter’ is a role that can be played by a driver, specifically one who ...  
<distinctions brought out in the rest of the definition>
For how to depict this in graphics, see C.5 (UML style) and CDG style (sub clause I.5  in Annex I).  The CDG style does not 
distinguish the various ways to depict roles as in the UML style (see treatment in C.5.1, C.5.2, and C.5.3).
B.3.3 Is-facet-of Proposition
When I see this:
driver
Concept Type: facet   
Definition: person  who ...
I know to vocalize it as:
The concept ‘driver’ is a facet (or aspect) of person, specifically just those characteristics of ‘person’ 
relevant to ... <distinctions brought out in the rest of the definition>
How to depict this in graphics, (UML style) is illustra ted in the EU-Rent Annex (see Annex G), in the “Customers” 
V ocabulary sub clause.
B.3.4 Partitive Verb Concept
When I see this:
body of shared meanings1 contains body of shared meanings2
Concept Type: partitive verb concept
Definition: the body of shared meanings  includes  everything in another  body of shared meanings
body of shared meanings  includes  body of shared concepts
Concept Type: partitive verb concept
I know to vocalize it as:
A body of shared meanings contains  other bodies of shared meanings.
A body of shared meanings includ es bodies of shared concepts.
For how to depict this in graphics, see C. 8 (UML style).  There is no specified way to  depict this in the CDG graphic notation.   
vocabulary1 incorporates vocabulary2
Concept Type: partitive verb concept
Definition: the vocabulary1 includes  each symbol  that is included in  the vocabulary2
Note: When more than one vocabulary is included, a hierarchy of inclusion can provide priority for 
selection of definitions.
vocabulary2 is incorporated into vocabulary1 
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      295vocabulary  includes  symbol
Concept Type: partitive verb concept
symbol  is included in  vocabulary
I know to vocalize it as:
A vocabulary incorporates (another) vocabulary.
A vocabulary includes symbols.
For how to depict this in graphics, see C. 8 (UML style).  There is no specified way to depict this in the CDG graphic notation.  
B.3.5 Classification (‘Pr edefined Extension’)
When I see this:
Canada
General Concept: country
I know to vocalize it as:
Canada is an instance of the concept ‘country’
(or, ‘Canada’ is a designatio n of an individual country)
For how to depict this in graphics, see the discussion of ‘Primary Name for an Individual Noun Concept’ above.  
Typically, this kind of entry is simply ‘indicated’ (or perhaps ‘adopted’), with no definition.  However, when a definition is 
written, its styling can specify the general concept, in which cas e, the ‘General Concept’ caption can be omitted.  For example , 
the entry below defines ‘Car Rental Industry’  to be an instance of  ‘semantic community’.  
Car Rental Industry  
Definition: the semantic community  that is the group of people who work in the business of renting cars
Commentary:
When you find this pattern, draw it in the UML style using UML’s arrow style for ‘instantiation’.  The notation has been 
adapted from standard UML notation to make it more ‘busine ss friendly’. For example, in UM L, in instance (‘object’) would 
be labeled as, Canada: country .  Predefined extension instances are not typically depicted in the box-in-box style.
B.3.6 Categorization Type
When I see this:
branch type
Definition: concept  that specializes  the concept  ‘branch ’ and that  classifies  a branch  based on its 
hours of operation  and car storage capacity
city branch
Concept Type: branch type   
Definition: branch  that operates in a city
296                                                                                                    Semantics of Business Vocabu lary and Business Rules, v1.3I know to vocalize it as:
The concept ‘branch type’ has instances that are certain categories of the concept ‘branch.’ 
The concept ‘city branch’ is a category of the concept ‘branch.’
The concept ‘city branch’ is a ‘branch type.’
For how to depict this in graphics, see C.7.2 (UML style).  There is no specified way to de pict this in the CDG graphic 
notation.  
Commentary:When you find this pattern -- a ‘Definition’ caption that begins,
concept
 that specializes  the concept  ‘other-concept ’ and that  classifies  an other-concept  based on...
-- it is a compact, textual way to say multiple things, as follows:
1. that the mentioned other-concept  has categories for which the other-concept  is the more general concept, and
2. that the entry being defined is itself a category of con cept, one whose instances are th e categories of the mentioned 
more general concept.
Furthermore, the vocabulary entries for th e certain category include a ‘Concept Type:’  caption that mentions  the categorization  
type.  For example, the vocabulary entry for ‘city branch’ mentions ‘branch type’ as its Concept Type.
B.3.7 Categorization Scheme
When I see this:
Branches by Type
Description: segmentation  that is for  branch  and subdivides  branch  based on branch type  
Necessity: Branches by Type  contains the categories  ‘airport branch ’ and ‘ city branch ’ and ‘ agency ’.
agency
Definition: branch  that does not  have a EU-Rent location  and has minimal car storage  and has 
on-demand operation  
Necessity: agency  is included in  Branches by Type .
airport branch
Definition: branch  that has a EU-Rent location  and has large car storage  and has 24-7 operation
Necessity: airport branch  is included in Branches by Type .
city branch
Definition: branch  that has a EU-Rent location  and has moderate car storage  and has long 
business hours  
Necessity: city branch  is included in Branches by Type .
I know to vocalize it as:
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      297‘Branches by Type’ is the name of a categorization scheme (or, in this case, a ‘segmenta-
tion’, which is a restricted case of categori zation scheme).  This scheme is for the general 
concept ‘branch’, presenting the instances of branch as divided into the categories that 
make up the scheme, according to the stated cr iteria.  Each category’s entry indicates being 
part of the scheme.
For how to depict this in graphics, see C.7.1 (UML style) and CDG style (sub clause I.3.2 in Annex I).
Commentary:When you find this pattern -- under a ‘name’ designation with a ‘Definition’ caption that begins,
the categorization scheme
 that is for the concept  ‘mentioned-other-concept ’ and subdivides  mentioned-other-
concept  based on...
orthe segmentation
 that is for the concept  ‘mentioned-other-concept ’ and subdivides   
mentioned-other-concept  based on...
-- it is a compact, textual way to say multiple things, as follows:
1. that the entry being defined is a categorization scheme (or a categorization scheme th at is a segmentation), and
2. that the mentioned concept is the concept that is the scheme is for.
Furthermore, each vocabulary en try for one of the categories in the scheme  identifies itself as part of the scheme  
using a ‘Necessity’ caption.  (N ote that a category can be part  of more than one scheme.)
B.4 Defining a Verb Co ncept for Convenience
The development of vocabularies and sets of elements of guid ance often calls for trade-offs of redundancy (in the sense of 
defining a concept both directly and indi rectly) against simplification of formul ation and representation. Consider, for 
example, the first of the ten introductory examples presented in Annex A.2.4:
It is necessary that each rental  has exactly one  requested car group .
This is easy to grasp. Now, consider the full form of this rule  if the rule were based solely on a sparse EU-Rent vocabulary.  
The rule would then be as follows:
It is necessary that each rental  has exactly one  car group  that is specified in  the car movement  that  
is included in  the rental .
As this simple example demonstrates, the full form of a rule (or advice) can become quite ver bose when several verb concepts 
are involved.
The compact form of this rule makes use of the short form  verb concept ‘ rental  has requested car group ’, a redundant 
concept that has been created fo r the purpose of simplification of formulation a nd representation.  This  verb concept specifies  
its instances as being derived from (equivalent to) the concatenation of other verb concepts -- the verbose  form -- as illustrated 
by the following entry th at specifies the concept:
298                                                                                                    Semantics of Business Vocabu lary and Business Rules, v1.3rental  has requested car group
Necessity: A rental  has a requested car group  if and only if the  requested car group  is the car 
group  that is specified in  the car movement  that is included in  the rental . 
This technique is particularly useful when the short form  verb concept is used in a number  of elements of guidance.  For 
another example, from Anne x G, the verb concept ‘ rented car  is assigned to  rental ’ is a basis element for three of the ten 
introductory examples.  
Note, however, the choice to apply this pattern is a matter of practice.  Decisions on reuse and redundancy are business 
decisions made by the semantic community (h ere, EU-Rent) to help it manage its body of shared meanings and vocabularies.
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      299Annex C - Use of UML Notati on in a Business Context to 
Represent SBVR-Style Vocabularies
(informative)
C.1 General
A purpose of the UML diagrams in Clauses 8 through 12 and An nex E is to display a vocabulary graphically. This kind of 
UML model is commonly called a ‘Business Object Model’ (BOM).  Note that diagrams in Clauses 8 through 12 also show 
SBVR’s MOF-based metamodel using an interpretation explai ned in Clause 23. The vocabulary interpretation described 
below and the MOF interpretation explained in Clause 23 use th e same diagrams, but the two interpretations should not be 
confused. The two interpretations are based on different profiles.
A BOM is commonly used to convey a business vocabulary (e.g.,  the SBVR vocabulary) so its use should be familiar.  The 
diagrams do not show any special stereotypes as long as conve ntions are explained.  This Annex provides that explanation.
C.2 General Concept (Noun Concept)
The primary term for a concept that is not  a role, individual noun concept, or verb concept is shown as a class (rectangle). Th e 
rectangle is labeled with the concept’s primary term, written ju st as the entry term would appear in a presentation of the 
vocabulary.  
If there are additional terms for the co ncept they can be added within the r ectangle, labeled as such (e.g., “ also:  is-category-of 
verb concept” as depicted in Figure C.1).
Figure C.1 - Two general concepts
C.3 Individual Noun Co ncept (Noun Concept)
The name given to an individual noun concept is shown as an instance specification (rectangle) . The name is followed by a 
colon and then by the term for its general concept.  This text string is underl ined within the rectangle.
While it is possible to have additional names for a given indivi dual noun concept (i.e., names that are synonyms), the non-
primary names of an individual noun concept are not typically  reflected on the diagram. Figure C.2 depicts two individual 
noun concepts. 
Figure C.2 - Two individual noun concepts

 300                                                                                                     Semantics of Business Voca bulary and Business Rules, v1.3Alternatively, an individual noun concept can be depicted as an  instance of its related general concept (noun concept), as in 
Figure C.3.
Figure C.3- Three individual noun concepts as instances of the related general concept
C.4 Verb Concepts
Use of the UML association notation works well for representing verb concepts in an SBVR-bas ed vocabulary diagram.  
However, it is important to remember that an SBVR verb concept is not an association.  A verb concept is a classifier that has 
particular semantics.Issue # 15623: revise text
C.4.1  Binary Verb Concepts
The verb concept wording of a binary verb concept, other than one using ‘has’, is shown as an association (a line between 
rectangles). If there is another verb concept wording for th e verb concept that is read in the opposite direction, only the act ive 
form of the wording is needed if the other wording is the normal passive form for the same verb.  
Alternatively, both wordings can be shown, one above the line and the other below.  Either th e ‘clockwise reading rule’ or a 
solid triangle as an arrow can be used to show the direction of readin g. C.4 illustrates three alte rnative presentations of a b inary 
verb concept. 

Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      301Figure C.4 - Three alternatives for presenting a binary verb concept
C.4.2    Binary Verb Concepts using ‘has’
For each verb concept wording using ‘has’, the second role name is shown as an a ssociation end name. The verb ‘has’ is not 
shown on the diagram when giving an association end name. E ach association end name in a diagram expresses a designation 
of a verb concept role. An end name implies ‘has’ as shown in Figure C.5.  Any verb phrase shown is assumed to be usable 
without the end name.
Figure C.5- Depicting the verb concept ‘cash rental has lowest rental price’ 
When a binary verb concept’s wording uses ‘has’ and there is no speciali zed role, the second role na me is still reflected on th e 
diagram in this consistent way (on the line  adjacent to the rectangle) and ‘has’ is no t displayed. This is illustrated in Figur e 
C.6.
Figure C.6- Depicting the verb concept ‘branch has country’
C.4.3  Verb Concepts wi th Arity of 3 or more 
For verb concepts with more than two ro les, the UML association notation is used .  The primary verb concept wording is 
shown, with the placeholders underlined as shown in Figure C.7.
Figure C.7- Depicting a verb concept with arity of three
 

 302                                                                                                     Semantics of Business Voca bulary and Business Rules, v1.3C.4.4  Characteristics
UML associations only apply to binary and higher-arity.  Or dinarily a characteristic is transformed into a UML Boolean 
attribute, as shown in Figure C.8.
Figure C.8- Depicting the characteristic ‘advance rental is assigned’ as a Boolean attribute
However, the SBVR characteristic is more accurately modeled in UML using an alternative style, which applies the same 
conventions described in sub clause H.4.3, adapted for the unary case shown in Figure C.9.
Figure C.9- Depicting the characteristic ‘advan ce rental is assigned’ using association notation
C.5 Roles
Note that a ‘role’ in SBVR is a concept in its own right.  
C.5.1   Role depicted as an Association End Name
A term for a role is typically shown as an  association end name.  Mul tiple appearances of the same role name coming into the 
same class imply a more general ‘role’ c oncept as well as the specific roles shown.
Note :  Figure C.10 shows two verb concept wordings for the same verb concept (see also sub clause C.4.2).
speech community  uses  vocabulary
vocabulary  has audience
Figure C.10- Depicting a role as an association end name
C.5.2  Role depicted using UML Stereotyping
Since a ‘role’ in SBVR is a concept in its  own right it can also be depicted as a class (rectangle), with UML stereotyping used  
to denote the general concept that it ranges over.  As illustrat ed in C.11, the stereotype <<rol e>> can be reflected for the cl ass 
or the generalization line can us e the stereotype <<is-role-of>>.

Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      303Figure C.11- Depicting a role as a class, with stereotyping
Issue # 15623:  replace text
C.5.3  Term for a Role in  a Verb Concept Wording
When a term for a role is used in a verb concept wording, a nd that wording is not an attributive form (e.g., “a has b”), then t he 
term for the role needs to be shown.  It is not shown as an a ssociation end because that would imply an attribut e form (e.g., 
“has”).  Instead, the term for the role is  underlined and shown, along with the verbal part of the verb concept wording.
Figure C.12 gives an example.  In the verb  concept “rental incurs late return charge” (from EU-Rent), ‘late return charge’ is a  
term for a role -- the general concept is ‘penalty charge’.  Rather than put “incur s” on the association line connecting “renta l” 
to “penalty charge,” th e text on the line incorp orates the term for the role and r eads, “incurs late return charge.”
Figure C.12- Example of a term for a role in a verb concept wording
C.6 Generalizations
Generalizations are shown in the norm al UML way as shown in Figure C.13.
Figure C.13- Two examples of generalization
 

 304                                                                                                     Semantics of Business Voca bulary and Business Rules, v1.3C.7 Categorization 
C.7.1  Categories and Categorization Schemes
A set of mutually-exclusive categories can be depicted by bringing the generalization lines together, as shown on the left in 
Figure C.14.  Contrast that with the diagram on the right whic h reflects two independent specia lizations -- i.e., a community 
can be both a semantic community and a sp eech community. Optionally, the name of a categorization scheme can be assigned 
to the set of categories, e.g. , ‘Rentals by Payment Type’.
Figure C.14- Depicting mutually-exclusive categories vs. independent specializations
C.7.2  Categories and Catego rization Types (Concept Types)
Use of UML powertype notation is not typical, but it can be us ed to show the categories speci fied by a categorization type 
(concept type).  Note that the second diagram in C.15 illustrates  a named categorization scheme (‘Branches by Type’) which is 
related to the categorization type ‘branch type.’ 

Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      305Figure C.15- Two examples of depicting the cat egories specified by a categorization type
C.8 Partitive Verb Concept
UML aggregation notation is used to represent partitive verb concepts.
The diagram on the left of Figure C.16 show s the verb concept wordings for the partitive verb concepts that ‘body of shared 
meanings’ is involved in.
body of shared meanings  includes  body of shared concepts
body of shared meanings  includes  body of shared guidance
The diagram on the left of Figur e C.16 also illustrates the verb  concept wordings for the parti tive verb concepts that ‘body of  
shared meanings’ is involved in.
body of shared meanings1 contains  body of shared meanings2
Note that the subscripts in the verb concept wording are not  reflected on the diagram.  
As the diagrams of Figure C.16 illustrate, reflecting the verb phrase of a partitive verb concept on the diagram is optional.
Figure C.16- Two examples of partitive verb concept
Issue # 16491:  replace text

 306                                                                                                     Semantics of Business Voca bulary and Business Rules, v1.3C.9 Verb Concept Objectification
Where a general concept objectifies a verb co ncept, an association class is used to depict the general concept, as shown in 
Figure C.17. A dashed line connects the association line for the verb concept with the box for the noun concept.  A binary verb  
concept is shown in a similar fashion, with the da shed line connecting to th e binary association line.
Figure C.17- Depicting verb  concept objectification
C.10 Multiplicities
Multiplicities are typically not shown. However, display of UML multiplicity is a diagram-level option. When UML 
multiplicity is used on a diagram (as a whole), this element is us ed to depict a formally-stated alethic necessity of a particu lar 
multiplicity.  UML multiplicity is used for no other case.  In a diagram that uses UML multiplicity, the default assumption for  
an unannotated association end is ‘*’ (which is in terpreted as ‘0 or more’ -- i.e., unconstrained).

Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      307  Annex D - Additional References
(informative)
D.1 Bibliography / Normative References
[AH] American Heritage Dictionary .
[Anto2001] Antonelli, A. Non-Monotonic Logic , Stanford Encyclopedia of Philosophy, 2001. Available from  
http://plato.stanford.edu/en tries/logic-nonmonotonic/
[Bloe1996] Bloesch, A.C., and Terry A. Halpin. “ConQuer: a Conceptual Query Language”. In Proc. ER’96: 15th 
Int. Conf. on Conceptual Modeling , 121-133: Springer LNCS, 1996. Available from  
http://www.orm.net/pdf/ER96.pdf
[Bloe1997] ________. “C onceptual Queries using ConQuer-II”. In Proc. ER’97: 16th Int. Conf. on Conceptual 
Modeling , 113-126: Springer LNCS, 1997. Availabl e from http://www.orm.net/pdf/ER97-final.pdf
[BMM] Business Rules Group. The Business Motivation Model ~ Busin ess Governance in a Volatile World . 1.2 
ed., Sept. 2005. Originally published as Organizing Business Plans ~ The St andard Model for Business Rule 
Motivation , Nov. 2000. Available from h ttp://www.BusinessRulesGroup.org
[BRM] Business Rules Group. Ronald G. Ross, ed. Business Rules Manifesto ~ The Principles of Rule 
Independence . 1.2 ed. The Business Rules Group, 2003. Up dated Jan. 8, 2003. PDF. Available from  
http://www.BusinessRulesGro up.org/brmanifesto.htm
[BRG2002] Business Rules Group. Defining Business Rules ~ What Are They Really? 4th ed., July 2002. 
Originally published as GUIDE Business Rules Project Report , 1995. Available from http://
www.BusinessRulesGroup.org
[BRJ2005] Editors of BRCommunity .com. “A Brief History of th e Business Rule Approach”. The Business Rules 
Journal 6, no. 1 (2005). Available from http ://www.BRCommunity.com/a2005/b216.html
[CDP] The Cambridge Dictionary of Philosophy . 2nd ed.: Cambridge University Press, 1999.
[CSILL] Cognitive Science Initiative: Language Lexicon . University of Houston.  Available from  
http://www.hfac.uh.edu/COGSCI/lang/Entries/
[Dean1997] Dean, Neville. The Essence of Discrete Mathematics , The Essence of Computing Series: Prentice-
Hall, 1997.
[Fitt2002 (or TTGG)] Fitting, Melvin. Types, Tableaus, and Gödel’ s God , Trends in Logic, Studia Logica Library. 
Dordrecht, the Netherlands: Kluw er Academic Publishers, 2002.
[Girl2000 (or MLP)] Girle, Rod A. Modal Logics and Philosophy : McGill-Queen's University Press, 2000.
 308                                                                                                     Semantics of Business Voca bulary and Business Rules, v1.3[Halp1989 (or HALT89)] Halpin, Terry A. “A Logical Anal ysis of Information Systems: Static Aspects of the 
Data-oriented Perspective”. PhD thesis,  Department of Computer Science, University of Queensland, 1989.
[Halp1998] ________. “Object-Role Modeling (ORM/NIAM)”. In Handbook on Architectures of Information 
Systems . Heidelberg: Springer, 1998.
[Halp2000] ________. Object-Role Modeling: An Overview . San Francisco: Springer, 2000. Available from  
http://www.orm.net/pdf/springer.pdf
[Halp2001 (or IMRD)] ________. Information Modeling and Relational Databases . San Francisco: Morgan 
Kaufmann, 2001.
[Halp2003a] ________. “Verbaliz ing Business Rules: Part 1”. The Business Rules Journal 4, no. 4 (2003). 
Available from http://www.BRComm unity.com/a2003/b138.html
[Halp2003b] ________.  “Verbalizing Business Rules: Part 2”. The Business Rules Journal 4, no. 6 (2003). 
Available from http://www.BRComm unity.com/a2003/b152.html
[Halp2003c] ________. “Verbaliz ing Business Rules: Part 3”. The Business Rules Journal 4, no. 8 (2003). 
Available from http://www.BRComm unity.com/a2003/b163.html
[Halp2003d] ________.  “Verbalizing Business Rules: Part 4”. The Business Rules Journal 4, no. 10 (2003). 
Available from http://www.BRComm unity.com/a2003/b172.html
[Halp2004 (or HALT2004)] ________. “Information Modeling and Higher-Order Types”. In Proc. CAiSE'04 
Workshops , eds. J. Grundspenkis and M. Kirkova, 1, 233-248: Riga Tech. University, 2004. Available from  
http://www.orm.net/p df/EMMSAD2004.pdf
[Halp2004b] ________. “Business Rule Verbalization”. In Lecture Notes in Informatics , eds. A. Doroshenko, Terry 
A. Halpin and S. Liddle, P-48, 39-52. Salt Lake City: Proc. ISTA-2004, 2004.
[Halp2004c] ________. “Verbaliz ing Business Rules: Part 5”. The Business Rules Journal 5, no. 2 (2004). 
Available from http://www.BRComm unity.com/a2004/b179.html
[Halp2004d] ________.  “Verbalizing Business Rules: Part 6”. The Business Rules Journal 5, no. 4 (2004). 
Available from http://www.BRComm unity.com/a2004/b183.html
[Halp2004e] ________. “Verbaliz ing Business Rules: Part 7”. The Business Rules Journal 5, no. 7 (2004). 
Available from http://www.BRComm unity.com/a2004/b198.html
[Halp2004f] ________. “Verbalizing Business Rules: Part 8”. The Business Rules Journal 5, no. 9 (2004). 
Available from http://www.BRComm unity.com/a2004/b205.html
[Halp2004g] ________.  “Verbalizing Business Rules: Part 9”. The Business Rules Journal 5, no. 12 (2004). 
Available from http://www.BRComm unity.com/a2004/b215.html
[Halp2005a] ________. “Verbalizing Business Rules: Part 10”. The Business Rules Journal 6, no. 4 (2005). 
Available from http://www.BRComm unity.com/a2005/b229.html
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      309[Halp2005b] ________. “Verbalizing Business Rules: Part 11”. The Business Rules Journal 6, no. 6 (2005). 
Available from http://www.BRCo mmunity.com/a2005/b238.html
[Halp2005c] ________. “Verbalizing Business Rules: Part 12”. The Business Rules Journal 6, no. 10 (2005). 
Available from http://www.BRCo mmunity.com/a2005/b252.html
[Halp2005d] ________. “Verbalizing Business Rules: Part 13”. The Business Rules Journal 6, no. 12 (2005). 
Available from http://www.BRCo mmunity.com/a2005/b261.html
[Halp1981 (or DL)] Halpin, Te rry A., and Rod A. Girle. Deductive Logic . 2nd ed. Brisbane: Logiqpress, 1981.
[Hunt1971 (or META)] Hunter, Geoffrey. An Introduction to the Metatheory  of Standard First Order Logic : 
University of California Press, 1971.
[IETF RFC 2396] Berners-Lee, Tim, R. Fielding, and L. Masinter. Uniform Resource Id entifiers (URI): Generic 
Syntax . The Internet Society, 1998. Updated August 1998. Available from http://www.ietf.org/rfc/rfc2396.txt
[ISO6093] International Organiza tion for Standardization (ISO). Information processing - Representation of 
numerical values in character stri ngs for information interchange .  ISO, 1985.
[ISO704] ________. Terminology work - Principles and Methods . English ed.: ISO, 2000.
[ISO1087-1] ________. Terminology work - Vocabulary - Part 1: Theory and Application . English/French ed.: 
ISO, 2000.
[ISO860] ________. Terminology work - Harmonization of Concepts and Terms .  ISO, 1996.
[ISO639-2] ________. Codes for the Representation of Names of Languages-- Part 2: Alpha-3 Code . Library of 
Congress, 2002. Available from http://www. loc.gov/standards/iso 639-2/langcodes.html
[ISO/IEC CD 24707] ________. Information technology -- Common Logic (CL) -- A Framework for a Family of 
Logic-Based Languages : ISO, 2005. Available from  
http://www.iso.org/iso/en/CatalogueDeta ilPage.CatalogueDet ail?CSNUMBER=39175
[Levi1983 (or LEVS)] Levinson, Stephen C. Pragmatics , Cambridge Textbooks in Linguistics: Cambridge 
University Press, 1983.
[MATH] PlanetMath.org . Available from http://planetmath.org/encyclopedia
[Mend1997 (or MEN97)] Mendelson, Elliott. Introduction to Mathematical Logic . 4th ed.: Chapman & Hall, 1997.
[MWCD] Merriam-Webster Collegiate Dictionary .
[MWDS] Merriam-Webster Dictionary of Synonyms .
[MWU] Merriam-Webster Unabridged .
 310                                                                                                     Semantics of Business Voca bulary and Business Rules, v1.3[Nijs1977] Nijssen, Sjir. “On the Gross Architecture for the Next Generation Database Management Systems.” In: 
Proc. IFIP’77, 1977 IFIP Working Conf. on Modelling in Data Base Management Systems , ed. B. Gilchrist, 327-
335: North Holland Publishing Company, 1977.
[Nijs1978] ________. “A Framework for Discussion.” In: ISO/TC97/SC5/WG3  and comments on 78.04/01  and 
78.05/03 , 1-144.
[Nijs1980] ________. “A Framework for Ad vanced Mass Storage Applications.” In: Proc. IFIP MEDINFO’80, 
3rd World Conference on  Medical Informatics : North Holland Publishing Company, 1980.
[Nijs1986] ________. “On Experience with Large-scale Te aching and Use of Fact-Based Conceptual Schemas in 
Industry and University.” In: Proc. DS-1’85: IFIP WG 2.6 Working Conference on Data Semantics , eds. T.B. Steel 
and R. Meersman, 189-204: North Holland Publishing Company, 1986.
[Nijs2006] Nijssen, Sjir, and R. Bijlsma. “A Conceptual  Structure of Knowledge as a Basis for Instructional 
Designs.” In: Proc. ICALT’06, IEEE: 6th Int. Conf. on Advanced Learning Technologies , eds. R. Kinshuk, P. 
Koper, P. Kommers, D. Kirschner, G. Sa mpson, and W.E. Didderen, 7-9: IEEE, 2006.
[NODE] The New Oxford Dictionary of English .
[Nolt1998 (or LSO)] Nolt, John, Denn is Rohatyn, and Achille Varzi. Logic . 2nd ed., Schaum's Outlines. New York: 
McGraw-Hill, 1998.
[ODE] Oxford Dictionary of English .
[OSM] Organizational Structure Metamodel : OMG, 2005.
[Peik (or PEIL)] Peikoff, Leonard. “The  Analytic-Synthetic Dichotomy”. In Rand1990 , 88-121.
[Rand1990 (or RANA90)] Rand, Ayn. Introduction to Obj ectivist Epistemology . expanded 2nd ed. New York: 
Meridian, 1990.
[Ross1997] Ross, Ronald G. The Business Rule Book -- Classify ing, Defining and Modeling Rules . 2nd ed. 
Houston, TX: Business Rule Solutions, Inc., 1997. Originally published as The Business Rule Book (1st Ed.) , 1994. 
Available from http://www.BRSolutions.com
[Ross2003] ________. Principles of the Business Rule Approach . Boston, MA: Addison-Wesley, 2003. Available 
from http://www.BRSolutions.com
[Ross2005] ________. Business Rule Concepts: Gett ing to the Point of Knowledge . 4th ed.: Business Rule 
Solutions, LLC, 2013. Available from http://www.BRSolutions.com
[RuleSpeak] Business Rule Solutions, LLC, 2001-20 14. PDF. Available from http://www.rulespeak.com/en/
[SEP] Stanford Encyclopedia of Philosophy . Edward N. Zalta, ed. The Metaphysics Research Lab, Center for the 
Study of Language and Information, Stanford Un iversity. Available from h ttp://plato.stanford.edu/
[SOED] Shorter Oxford Dictionary of English .
Semantics of Business Vocabulary and Business Rules, v1.3                                                                                                      311[Sowa] . “Ontology, Metadata, and Semi otics”. John Sowa Ontology Website.  
Available from http://www.jfsowa.com/ontology/ontometa.htm 
[SubePLTS (or PLTS)] Suber, Peter. Propositional Logic Terms and Symbols . Philosophy Department, Earlham 
College, 1997. Available from http://www.ear lham.edu/~peters/cou rses/log/terms2.htm
[SubeGFOL (or GF OL)] ________. Glossary of First-Order Logic . Philosophy Department, Earlham College, 
1999-2002. Available from http://www.earlh am.edu/~peters/courses/logsys/glossary.htm
[UML2infr] Object Management Group (OMG). Unified Modeling Langu age: Infrastructure . Ver. 2.0: OMG.
[Unicode4]  “The Unicode Standard, Version 4.0.0”. In The Unicode Standard, Version 4.0 . Boston, MA: Addison-
Wesley, 2003. Available from http://www.unicode.org/versions/Unicode4.0.0/b1.pdf
[USG] The Unicode Consortium. Glossary of Unicode Terms . 1991-205. Updated Nov. 17 2004. Available from  
http://www.unicode.org/glossary/
[W3ID] Webster’ s 3rd New International Dictionary .
[WD] Webster’ s Dictionary .
[XMI2.1] XML Metadata Interchange (XMI) . Ver. 2.1: OMG.
 312                                                                                                     Semantics of Business Voca bulary and Business Rules, v1.3
