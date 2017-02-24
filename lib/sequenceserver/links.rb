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
      taxa["agraulis_vanillae_helico3_core_32_85_1"] = "Agraulis_vanillae_helico3"
      taxa["amyelois_transitella_v1_core_32_85_1"] = "Amyelois_transitella_v1"
      taxa["bicyclus_anynana_nba01_core_32_85_1"] = "Bicyclus_anynana_nba01"
      taxa["bicyclus_anynana_v1x2_core_32_85_1"] = "Bicyclus_anynana_v1x2"
      taxa["bombyx_mori_core_32_85_1"] = "Bombyx_mori"
      taxa["bombyx_mori_asm15162v1_core_32_85_1"] = "Bombyx_mori_asm15162v1"
      taxa["callimorpha_dominula_k41_core_32_85_1"] = "Callimorpha_dominula_k41"
      taxa["calycopis_cecrops_v1x1_core_32_85_1"] = "Calycopis_cecrops_v1x1"
      taxa["cameraria_ohridella_k41_core_32_85_1"] = "Cameraria_ohridella_k41"
      taxa["chilo_suppressalis_csuogs1_core_32_85_1"] = "Chilo_suppressalis_csuogs1"
      taxa["danaus_plexippus_core_32_85_1"] = "Danaus_plexippus"
      taxa["danaus_plexippus_v3_core_32_85_1"] = "Danaus_plexippus_v3"
      taxa["dryas_iulia_helico3_core_32_85_1"] = "Dryas_iulia_helico3"
      taxa["eueides_tales_helico3_core_32_85_1"] = "Eueides_tales_helico3"
      taxa["glyphotaelius_pellucidus_k51_core_32_85_1"] = "Glyphotaelius_pellucidus_k51"
      taxa["heliconius_besckei_helico3_core_32_85_1"] = "Heliconius_besckei_helico3"
      taxa["heliconius_burneyi_helico3_core_32_85_1"] = "Heliconius_burneyi_helico3"
      taxa["heliconius_cydno_helico3_core_32_85_1"] = "Heliconius_cydno_helico3"
      taxa["heliconius_demeter_helico3_core_32_85_1"] = "Heliconius_demeter_helico3"
      taxa["heliconius_elevatus_helico3_core_32_85_1"] = "Heliconius_elevatus_helico3"
      taxa["heliconius_erato_mother_helico3_core_32_85_1"] = "Heliconius_erato_mother_helico3"
      taxa["heliconius_erato_x_himera_f1_helico3_core_32_85_1"] = "Heliconius_erato_x_himera_F1_helico3"
      taxa["heliconius_erato_demophoon_v1_core_32_85_1"] = "Heliconius_erato_demophoon_v1"
      taxa["heliconius_erato_lativitta_v3_core_32_85_1"] = "Heliconius_erato_lativitta_v1"
      taxa["heliconius_erato_lativitta_v1_core_32_85_1"] = "Heliconius_erato_lativitta_v1"
      taxa["heliconius_hecale_helico3_core_32_85_1"] = "Heliconius_hecale_helico3"
      taxa["heliconius_hecale_old_helico3_core_32_85_1"] = "Heliconius_hecale_old_helico3"
      taxa["heliconius_hecalesia_helico3_core_32_85_1"] = "Heliconius_hecalesia_helico3"
      taxa["heliconius_himera_helico3_core_32_85_1"] = "Heliconius_himera_helico3"
      taxa["heliconius_himera_father_helico3_core_32_85_1"] = "Heliconius_himera_father_helico3"
      taxa["heliconius_melpomene_melpomene_core_32_85_1"] = "Heliconius_melpomene_melpomene_hmel1"
      taxa["heliconius_melpomene_core_32_85_1"] = "Heliconius_melpomene_melpomene_hmel1"
      taxa["heliconius_melpomene_helico3_core_32_85_1"] = "Heliconius_melpomene_helico3"
      taxa["heliconius_melpomene_melpomene_hmel2_core_32_85_1"] = "Heliconius_melpomene_melpomene_hmel2"
      taxa["heliconius_melpomene_hmel2_core_32_85_1"] = "Heliconius_melpomene_melpomene_hmel2"
      taxa["heliconius_numata_helico3_core_32_85_1"] = "Heliconius_numata_helico3"
      taxa["heliconius_pardalinus_helico3_core_32_85_1"] = "Heliconius_pardalinus_helico3"
      taxa["heliconius_sara_helico3_core_32_85_1"] = "Heliconius_sara_helico3"
      taxa["heliconius_telesiphe_helico3_core_32_85_1"] = "Heliconius_telesiphe_helico3"
      taxa["heliconius_telesiphe_contaminated_helico3_core_32_85_1"] = "Heliconius_telesiphe_contaminated_helico3"
      taxa["heliconius_timareta_helico3_core_32_85_1"] = "Heliconius_timareta_helico3"
      taxa["hepialus_sylvina_k51_core_32_85_1"] = "Hepialus_sylvina_k51"
      taxa["laparus_doris_helico3_core_32_85_1"] = "Laparus_doris_helico3"
      taxa["lerema_accius_v1x1_core_32_85_1"] = "Lerema_accius_v1x1"
      taxa["limnephilus_lunatus_v1_core_32_85_1"] = "Limnephilus_lunatus_v1"
      taxa["manduca_sexta_msex1_core_32_85_1"] = "Manduca_sexta_msex1"
      taxa["melitaea_cinxia_core_32_85_1"] = "Melitaea_cinxia"
      taxa["neruda_aoede_contaminated_helico3_core_32_85_1"] = "Neruda_aoede_contaminated_helico3"
      taxa["operophtera_brumata_v1_core_32_85_1"] = "Operophtera_brumata_v1"
      taxa["papilio_glaucus_v1x1_core_32_85_1"] = "Papilio_glaucus_v1x1"
      taxa["papilio_machaon_papma1_core_32_85_1"] = "Papilio_machaon_papma1"
      taxa["papilio_polytes_ppol1_core_32_85_1"] = "Papilio_polytes_ppol1"
      taxa["papilio_polytes_ppol1_refseq__core_32_85_1"] = "Papilio_polytes_ppol1_refseq"
      taxa["papilio_xuthus_papxu1_core_32_85_1"] = "Papilio_xuthus_papxu1"
      taxa["papilio_xuthus_pxut1_core_32_85_1"] = "Papilio_xuthus_pxut1"
      taxa["papilio_xuthus_pxut1_refseq_core_32_85_1"] = "Papilio_xuthus_pxut1_refseq"
      taxa["pararge_aegeria_k51_core_32_85_1"] = "Pararge_aegeria_k51"
      taxa["phoebis_sennae_v1x1_core_32_85_1"] = "Phoebis_sennae_v1x1"
      taxa["pieris_napi_das5_core_32_85_1"] = "Pieris_napi_das5"
      taxa["plodia_interpunctella_v1_core_32_85_1"] = "Plodia_interpunctella_v1"
      taxa["plutella_xylostella_dbmfjv1x1_core_32_85_1"] = "Plutella_xylostella_dbmfjv1x1"
      taxa["polygonia_c_album_k51_core_32_85_1"] = "Polygonia_c_album_k51"
      taxa["spodoptera_frugiperda_v2_core_32_85_1"] = "Spodoptera_frugiperda_v2"

#      if title.match(TITLE_PATTERN)
#        assembly = Regexp.last_match[1]
#        type = Regexp.last_match[2]
#        accession = id
#      elsif id.match(ID_PATTERN)
      if id.match(ID_PATTERN)
        assembly = Regexp.last_match[1]
        type = Regexp.last_match[2]
        accession = Regexp.last_match[3]
      end
      return nil unless accession
      return nil unless taxa.has_key?(assembly)
      assembly = encode taxa[assembly]

      accession = encode accession
      colon = ':'
      url = "http://ensembl.lepbase.org/#{assembly}"
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
        :icon  => 'fa-external-link'#,
#        :img  => 'img/e-lepbase.png'
      }
    end

  end
end


# [1]: https://stackoverflow.com/questions/2824126/whats-the-difference-between-uri-escape-and-cgi-escape
