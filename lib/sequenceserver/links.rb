module SequenceServer
  # Module to contain methods for generating sequence retrieval links.
  module Links
    require 'erb'

    # Provide a method to URL encode _query parameters_. See [1].
    include ERB::Util
    #
    alias_method :encode, :url_encode

    TITLE_PATTERN = /(\S+)\s(\S+)/
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
      return nil unless title.match(TITLE_PATTERN)
      assembly = Regexp.last_match[1]
      type = Regexp.last_match[2]
      accession = id
      assembly = encode assembly
      accession = encode accession
      colon = encode ':'
      url = "http://ensembl.lepbase.org/#{assembly}"
      if type == 'protein' || type == 'aa'
        url = "#{url}/Transcript/ProteinSummary?db=core;p=#{accession}"
      elsif type == 'cds' || type == 'transcript'
        url = "#{url}/Transcript/Summary?db=core;t=#{accession}"
      elsif type == 'gene'
        url = "#{url}/Gene/Summary?db=core;g=#{accession}"
      elsif type == 'contig' || type == 'scaffold' || type == 'chromosome'
        subjstart = encode self.subjstart
        subjend = encode self.subjend
        if subjstart > subjend 
          subjend = encode self.subjstart
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
      taxa = {}
      taxa.default = 0
      taxa["agraulis_vanillae_helico2_core_27_80_1"] = 398452
      taxa["bicyclus_anynana_nba01_core_27_80_1"] = 3993118
      taxa["bombyx_mori_core_27_80_1"] = 8023338
      taxa["chilo_suppressalis_csuogs1_core_27_80_1"] = 8177422
      taxa["danaus_plexippus_core_27_80_1"] = 8555660
      taxa["eueides_tales_helico2_core_27_80_1"] = 2460429
      taxa["heliconius_besckei_helico2_core_27_80_1"] = 2990818
      taxa["heliconius_burneyi_helico2_core_27_80_1"] = 3367821
      taxa["heliconius_cydno_helico2_core_27_80_1"] = 3718864
      taxa["heliconius_demeter_helico2_core_27_80_1"] = 4022736
      taxa["heliconius_elevatus_helico2_core_27_80_1"] = 4313467
      taxa["heliconius_erato_helico2_core_27_80_1"] = 4439085
      taxa["heliconius_erato_himera_helico2_core_27_80_1"] = 4501982
      taxa["heliconius_hecale_helico1_core_27_80_1"] = 4589812
      taxa["heliconius_himera_helico1_core_27_80_1"] = 4685331
      taxa["heliconius_melpomene_core_27_80_1"] = 8555662
      taxa["heliconius_melpomene_helico2_core_27_80_1"] = 6808582
      taxa["heliconius_melpomene_hmel2_core_27_80_1"] = 154377
      taxa["heliconius_numata_helico2_core_27_80_1"] = 223205
      taxa["heliconius_pardalinus_helico2_core_27_80_1"] = 8869409
      taxa["heliconius_telesiphe_helico2_core_27_80_1"] = 938851
      taxa["heliconius_timareta_helico2_core_27_80_1"] = 6973228
      taxa["laparus_doris_helico2_core_27_80_1"] = 7235969
      taxa["lerema_accius_v1x1_core_27_80_1"] = 8568982
      taxa["manduca_sexta_msex1_core_27_80_1"] = 8573293
      taxa["melitaea_cinxia_core_27_80_1"] = 8616757
      taxa["neruda_aoede_helico2_core_27_80_1"] = 7923715
      taxa["papilio_glaucus_v1x1_core_27_80_1"] = 155174
      taxa["pieris_napi_das5_core_27_80_1"] = 9250926
      taxa["plodia_interpunctella_v1_core_27_80_1"] = 8761949
      taxa["plutella_xylostella_dbmfjv1x1_core_27_80_1"] = 8770212

      return nil unless title.match(TITLE_PATTERN)
      assembly = Regexp.last_match[1]
      type = Regexp.last_match[2]
      taxid = taxa[assembly]
      return nil unless type == 'contig' || type == 'scaffold' || type == 'chromosome'
      accession = id
      assembly = encode assembly
      accession = encode accession
      colon = encode ':'
      subjstart = encode self.subjstart
        subjend = encode self.subjend
        if subjstart > subjend 
          subjend = encode self.subjstart
          subjstart = self.subjend
        end
      url = "http://webapollo.lepbase.org/apollo/annotator/loadLink?loc=#{accession}#{colon}#{subjstart}..#{subjend}&organism=#{taxid}&tracks=mRNA"
      
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
