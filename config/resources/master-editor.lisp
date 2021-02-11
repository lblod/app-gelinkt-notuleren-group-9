;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; TEMPLATES ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-resource template ()
  :class (s-prefix "ext:Template")
  :properties `((:title :string ,(s-prefix "dct:title"))
                (:matches :string-set ,(s-prefix "ext:templateMatches"))
                (:body :string ,(s-prefix "ext:templateContent"))
                (:contexts :uri-set ,(s-prefix "ext:activeInContext"))
                (:disabled-in-contexts :uri-set ,(s-prefix "ext:disabledInContext")))
  :resource-base (s-url "http://data.lblod.info/templates/")
  :features `(no-pagination-defaults)
  :on-path "templates")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DOCUMENTS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-resource editor-document ()
  :class (s-prefix "ext:EditorDocument")
  :properties `((:title :string ,(s-prefix "dct:title"))
                (:content :string ,(s-prefix "ext:editorDocumentContent"))
                (:context :string ,(s-prefix "ext:editorDocumentContext"))
                (:created-on :datetime ,(s-prefix "pav:createdOn"))
                (:updated-on :datetime ,(s-prefix "pav:lastUpdateOn"))
                (:starred :boolean ,(s-prefix "tmp:starred"))
                (:origin :string ,(s-prefix "pav:providedBy"))) ;;de gemeente Niel
  :has-one `((editor-document :via ,(s-prefix "pav:previousVersion")
                              :as "previous-version")
             (editor-document :via ,(s-prefix "pav:previousVersion")
                              :inverse t
                              :as "next-version")
             (document-container :via ,(s-prefix "pav:hasVersion")
                                 :inverse t
                                 :as "document-container"))
  :has-many `((tasklist-solution :via ,(s-prefix "ext:editorDocumentTasklistSolution")
                                 :as "tasklist-solutions"))
  :resource-base (s-url "http://data.lblod.info/editor-documents/")
  :features `(no-pagination-defaults)
  :on-path "editor-documents")
(define-resource concept-scheme ()
  :class (s-prefix "skos:ConceptScheme")
  :properties `((:label :string ,(s-prefix "skos:prefLabel")))
  :has-many `((concept :via ,(s-prefix "skos:inScheme")
                       :inverse t
                       :as "concepts")
              (concept :via ,(s-prefix "skos:topConceptOf")
                       :inverse t
                       :as "top-concepts"))
  :resource-base (s-url "http://lblod.data.gift/concept-schemes/")
  :features `(include-uri)
  :on-path "concept-schemes"
)

(define-resource concept ()
  :class (s-prefix "skos:Concept")
  :properties `((:label :string ,(s-prefix "skos:prefLabel"))
                (:notation :string ,(s-prefix "skos:notation"))
                (:search-label :string ,(s-prefix "ext:searchLabel")))
  :has-many `((concept-scheme :via ,(s-prefix "skos:inScheme")
                              :as "concept-schemes")
              (concept-scheme :via ,(s-prefix "skos:topConceptOf")
                              :as "top-concept-schemes"))
  :resource-base (s-url "http://lblod.data.gift/concepts/")
  :features `(include-uri)
  :on-path "concepts"
)

(define-resource document-container ()
  :class (s-prefix "ext:DocumentContainer")
  :has-one `((editor-document :via ,(s-prefix "pav:hasCurrentVersion")
                              :as "current-version")
             (concept :via ,(s-prefix "ext:editorDocumentStatus")
                                     :as "status")
             (editor-document-folder :via ,(s-prefix "ext:editorDocumentFolder")
                                     :as "folder")
             (bestuurseenheid :via ,(s-prefix "dct:publisher")
                              :as "publisher"))
  :has-many `((editor-document :via ,(s-prefix "pav:hasVersion")
                               :as "revisions")
              (versioned-agenda :via ,(s-prefix "ext:hasVersionedAgenda")
                                :as "versioned-agendas")
              (versioned-behandeling :via ,(s-prefix "ext:hasVersionedBehandeling")
                                     :as "versioned-behandelingen")
              (versioned-notulen :via ,(s-prefix "ext:hasVersionedNotulen")
                                 :as "versioned-notulen")
              (versioned-besluiten-lijst :via ,(s-prefix "ext:hasVersionedBesluitenLijst")
                                         :as "versioned-besluiten-lijsten"))
  :resource-base (s-url "http://data.lblod.info/document-containers/")
  :on-path "document-containers")

(define-resource editor-document-status ()
  :class (s-prefix "ext:EditorDocumentStatus")
  :properties `((:name :string ,(s-prefix "ext:EditorDocumentStatusName")))
  :resource-base (s-url "http://data.lblod.info/editor-document-statuses/")
  :features `(no-pagination-defaults)
  :on-path "editor-document-statuses")

(define-resource editor-document-folder ()
  :class (s-prefix "ext:EditorDocumentFolder")
  :properties `((:name :string ,(s-prefix "ext:EditorDocumentFolderName")))
  :resource-base (s-url "http://data.lblod.info/editor-document-folders/")
  :features `(no-pagination-defaults)
  :on-path "editor-document-folders")
