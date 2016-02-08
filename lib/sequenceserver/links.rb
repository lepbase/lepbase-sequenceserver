module SequenceServer
  # Module to contain methods for generating sequence retrieval links.
  module Links
    require 'erb'

    # Provide a method to URL encode _query parameters_. See [1].
    include ERB::Util
    #
    alias_method :encode, :url_encode

    TITLE_PATTERN = /(\S+)\s(\S+)/
    ID_PATTERN = /(.+?)__(.+?)__(.+)/
    # Link generators return a Hash like below.
    #
    # {
    #   # Required. Display title.
    #   :title => "title",
    #
    #   # Required. Generated url.
    #   :url => url,
    #
    #   # Optional. Left-right order in which the link should appear.
    #   :order => num,
    #
    #   # Optional. Classes, if any, to apply to the link.
    #   :class => "class1 class2",
    #
    #   # Optional. Class name of a FontAwesome icon to use.
    #   :icon => "fa-icon-class"
    # }
    #
    # If no url could be generated, return nil.
    #
    # Helper methods
    # --------------
    #
    # Following helper methods are available to help with link generation.
    #
    #   encode:
    #     URL encode query params.
    #
    #     Don't use this function to encode the entire URL. Only params.
    #
    #     e.g:
    #         sequence_id = encode sequence_id
    #         url = "http://www.ncbi.nlm.nih.gov/nucleotide/#{sequence_id}"
    #
    #   querydb:
    #     Returns an array of databases that were used for BLASTing.
    #
    #   whichdb:
    #     Returns the database from which the given hit came from.
    #
    #     e.g:
    #
    #         hit_database = whichdb
    #
    # Examples:
    # ---------
    # See methods provided by default for an example implementation.

    def sequence_viewer
      accession  = encode self.accession
      database_ids = encode querydb.map(&:id).join(' ')
      url = "get_sequence/?sequence_ids=#{accession}" \
            "&database_ids=#{database_ids}"

      {
        :order => 0,
        :url   => url,
        :title => 'Sequence',
        :class => 'view-sequence',
        :icon  => 'fa-eye'
      }
    end

    def fasta_download
      accession  = encode self.accession
      database_ids = encode querydb.map(&:id).join(' ')
      url = "get_sequence/?sequence_ids=#{accession}" \
            "&database_ids=#{database_ids}&download=fasta"

      {
        :order => 1,
        :title => 'FASTA',
        :url   => url,
        :class => 'download',
        :icon  => 'fa-download'
      }
    end

    def lepbase
      taxa = {}
      taxa.default = 0
     # taxa["agraulis_vanillae_helico2_core_27_80_1"] = "Agraulis_vanillae_helico2"
      taxa["bicyclus_anynana_nba01_core_27_80_1"] = "Bicyclus_anynana_nba01"
      taxa["bombyx_mori_core_27_80_1"] = "Bombyx_mori"
      taxa["chilo_suppressalis_csuogs1_core_27_80_1"] = "Chilo_suppressalis_csuogs1"
      taxa["danaus_plexippus_core_27_80_1"] = "Danaus_plexippus"
    #  taxa["eueides_tales_helico2_core_27_80_1"] = "Eueides_tales_helico2"
    #  taxa["heliconius_besckei_helico2_core_27_80_1"] = "Heliconius_besckei_helico2"
    #  taxa["heliconius_burneyi_helico2_core_27_80_1"] = "Heliconius_burneyi_helico2"
    #  taxa["heliconius_cydno_helico2_core_27_80_1"] = "Heliconius_cydno_helico2"
    #  taxa["heliconius_demeter_helico2_core_27_80_1"] = "Heliconius_demeter_helico2"
    #  taxa["heliconius_elevatus_helico2_core_27_80_1"] = "Heliconius_elevatus_helico2"
    #  taxa["heliconius_erato_helico2_core_27_80_1"] = "Heliconius_erato_helico2"
    #  taxa["heliconius_erato_himera_helico2_core_27_80_1"] = "Heliconius_erato_himera_helico2"
    #  taxa["heliconius_hecale_helico1_core_27_80_1"] = "Heliconius_hecale_helico1"
    #  taxa["heliconius_himera_helico1_core_27_80_1"] = "Heliconius_himera_helico1"
      taxa["heliconius_melpomene_core_27_80_1"] = "Heliconius_melpomene"
    #  taxa["heliconius_melpomene_helico2_core_27_80_1"] = "Heliconius_melpomene_helico2"
      taxa["heliconius_melpomene_hmel2_core_27_80_1"] = "Heliconius_melpomene_hmel2"
    #  taxa["heliconius_numata_helico2_core_27_80_1"] = "Heliconius_numata_helico2"
    #  taxa["heliconius_pardalinus_helico2_core_27_80_1"] = "Heliconius_pardalinus_helico2"
    #  taxa["heliconius_telesiphe_helico2_core_27_80_1"] = "Heliconius_telesiphe_helico2"
    #  taxa["heliconius_timareta_helico2_core_27_80_1"] = "Heliconius_timareta_helico2"
    #  taxa["laparus_doris_helico2_core_27_80_1"] = "Laparus_doris_helico2"
      taxa["lerema_accius_v1x1_core_27_80_1"] = "Lerema_accius_v1x1"
      taxa["manduca_sexta_msex1_core_27_80_1"] = "Manduca_sexta_msex1"
      taxa["melitaea_cinxia_core_27_80_1"] = "Melitaea_cinxia"
    #  taxa["neruda_aoede_helico2_core_27_80_1"] = "Neruda_aoede_helico2"
      taxa["papilio_glaucus_v1x1_core_27_80_1"] = "Papilio_glaucus_v1x1"
      taxa["pieris_napi_das5_core_27_80_1"] = "Pieris_napi_das5"
      taxa["plodia_interpunctella_v1_core_27_80_1"] = "Plodia_interpunctella_v1"
      taxa["plutella_xylostella_dbmfjv1x1_core_27_80_1"] = "Plutella_xylostella_dbmfjv1x1"

      if title.match(TITLE_PATTERN)
        assembly = Regexp.last_match[1]
        type = Regexp.last_match[2]
        accession = id
      elsif id.match(ID_PATTERN)
        assembly = Regexp.last_match[1]
        type = Regexp.last_match[2]
        accession = Regexp.last_match[3]
      end
      return nil unless accession
      assembly = encode taxa[assembly]
      return nil if assembly == 0
      
      accession = encode accession
      colon = ':'
      url = "http://v1.ensembl.lepbase.org/#{assembly}"
      if type == 'protein' || type == 'aa'
        url = "#{url}/Transcript/ProteinSummary?db=core;p=#{accession}"
      elsif type == 'cds' || type == 'transcript'
        url = "#{url}/Transcript/Summary?db=core;t=#{accession}"
      elsif type == 'gene'
        url = "#{url}/Gene/Summary?db=core;g=#{accession}"
      elsif type == 'contig' || type == 'scaffold' || type == 'chromosome'
        subjstart = self.subjstart
        subjend = self.subjend
        if subjstart > subjend 
          subjend = self.subjstart
          subjstart = self.subjend
        end
        url = "#{url}/Location/View?r=#{accession}#{colon}#{subjstart}-#{subjend}"
      end
      #  url ="#{url};j=#{whichdb}"
      {
        :order => 2,
        :title => 'lepbase',
        :url   => url,
        :icon  => 'fa-external-link',
        :img  => 'img/e-lepbase.png'
      }
    end

    def apollo
    return nil
      taxa = {}
      taxa.default = 0
      taxa["bicyclus_anynana_nba01_core_27_80_1"] = 3993118
      taxa["bombyx_mori_core_27_80_1"] = 9255869
      taxa["chilo_suppressalis_csuogs1_core_27_80_1"] = 9741729
      taxa["danaus_plexippus_core_27_80_1"] = 8555660
      taxa["heliconius_melpomene_core_27_80_1"] = 8555662
      taxa["heliconius_melpomene_hmel2_core_27_80_1"] = 154377
      taxa["lerema_accius_v1x1_core_27_80_1"] = 8568982
      taxa["manduca_sexta_msex1_core_27_80_1"] = 8573293
      taxa["melitaea_cinxia_core_27_80_1"] = 8616757
      taxa["papilio_glaucus_v1x1_core_27_80_1"] = 155174
      taxa["pieris_napi_das5_core_27_80_1"] = 9250926
      taxa["plodia_interpunctella_v1_core_27_80_1"] = 8761949
      taxa["plutella_xylostella_dbmfjv1x1_core_27_80_1"] = 8770212
      taxa["agraulis_vanillae_helico2_core_27_80_1"] = 16
      taxa["eueides_tales_helico2_core_27_80_1"] = 55999
      taxa["heliconius_besckei_helico2_core_27_80_1"] = 84651
      taxa["heliconius_burneyi_helico2_core_27_80_1"] = 146538
      taxa["heliconius_cydno_helico2_core_27_80_1"] = 248612
      taxa["heliconius_demeter_helico2_core_27_80_1"] = 302875
      taxa["heliconius_elevatus_helico2_core_27_80_1"] = 2516986
      taxa["heliconius_erato_helico2_core_27_80_1"] = 3225564
      taxa["heliconius_erato_himera_helico2_core_27_80_1"] =3364677 
      taxa["heliconius_hecale_helico1_core_27_80_1"] = 3502068
      taxa["heliconius_himera_helico1_core_27_80_1"] = 5456852
      taxa["heliconius_melpomene_helico2_core_27_80_1"] = 10548505
      taxa["heliconius_numata_helico2_core_27_80_1"] = 5738932
      taxa["heliconius_pardalinus_helico2_core_27_80_1"] = 5955216
      taxa["heliconius_telesiphe_helico2_core_27_80_1"] = 6871724
      taxa["heliconius_timareta_helico2_core_27_80_1"] = 8086780
      taxa["laparus_doris_helico2_core_27_80_1"] = 7632519
      taxa["neruda_aoede_helico2_core_27_80_1"] = 7288355

      domain = {}
      domain.default = "webapollo.lepbase.org"
      # replace the following section with a regexp that looks for helico[12]
      domain["agraulis_vanillae_helico2_core_27_80_1"] = "webapollodiscovar.lepbase.org"
      domain["eueides_tales_helico2_core_27_80_1"] = "webapollodiscovar.lepbase.org"
      domain["heliconius_besckei_helico2_core_27_80_1"] = "webapollodiscovar.lepbase.org"
      domain["heliconius_burneyi_helico2_core_27_80_1"] = "webapollodiscovar.lepbase.org"
      domain["heliconius_cydno_helico2_core_27_80_1"] = "webapollodiscovar.lepbase.org"
      domain["heliconius_demeter_helico2_core_27_80_1"] = "webapollodiscovar.lepbase.org"
      domain["heliconius_elevatus_helico2_core_27_80_1"] = "webapollodiscovar.lepbase.org"
      domain["heliconius_erato_helico2_core_27_80_1"] = "webapollodiscovar.lepbase.org"
      domain["heliconius_erato_himera_helico2_core_27_80_1"] = "webapollodiscovar.lepbase.org"
      domain["heliconius_hecale_helico1_core_27_80_1"] = "webapollodiscovar.lepbase.org"
      domain["heliconius_himera_helico1_core_27_80_1"] = "webapollodiscovar.lepbase.org"
      domain["heliconius_melpomene_helico2_core_27_80_1"] = "webapollodiscovar.lepbase.org"
      domain["heliconius_numata_helico2_core_27_80_1"] = "webapollodiscovar.lepbase.org"
      domain["heliconius_pardalinus_helico2_core_27_80_1"] = "webapollodiscovar.lepbase.org"
      domain["heliconius_telesiphe_helico2_core_27_80_1"] = "webapollodiscovar.lepbase.org"
      domain["heliconius_timareta_helico2_core_27_80_1"] = "webapollodiscovar.lepbase.org"
      domain["laparus_doris_helico2_core_27_80_1"] = "webapollodiscovar.lepbase.org"
      domain["neruda_aoede_helico2_core_27_80_1"] = "webapollodiscovar.lepbase.org"

      if title.match(TITLE_PATTERN)
        assembly = Regexp.last_match[1]
        type = Regexp.last_match[2]
        accession = id
      elsif id.match(ID_PATTERN)
        assembly = Regexp.last_match[1]
        type = Regexp.last_match[2]
        accession = Regexp.last_match[3]
      end
      return nil unless accession
      taxid = taxa[assembly]
      domainurl = domain[assembly]
      return nil if domainurl == "webapollodiscovar.lepbase.org"
      return nil unless type == 'contig' || type == 'scaffold' || type == 'chromosome'
      assembly = encode assembly
      accession = encode accession
      colon = ':'
      subjstart = self.subjstart
      subjend = self.subjend
      if subjstart > subjend 
        subjend = self.subjstart
        subjstart = self.subjend
      end
      url = "http://#{domainurl}/apollo/annotator/loadLink?loc=#{accession}#{colon}#{subjstart}..#{subjend}&organism=#{taxid}&tracks=mRNA"
      
      {
        :order => 3,
        :title => 'webapollo',
        :url   => url,
        :icon  => 'fa-external-link',
        :img  => 'img/a-lepbase.png'
      }
    end


  end
end

# [1]: https://stackoverflow.com/questions/2824126/whats-the-difference-between-uri-escape-and-cgi-escape
