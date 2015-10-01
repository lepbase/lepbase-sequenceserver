module SequenceServer
  # Module to contain methods for generating sequence retrieval links.
  module Links
    require 'erb'

    # Provide a method to URL encode _query parameters_. See [1].
    include ERB::Util
    #
    alias_method :encode, :url_encode

    TITLE_PATTERN = /(.+?_.+?_.+?)_.+?\s(\S+)/
#	aa|Bombyx_mori|NP_6723934.1
#	cds|Bombyx_mori|NP_6723934.1
#	transcript|Bombyx_mori|NP_6723934.1
#	gene|Bombyx_mori|NM_6723934.1
#	ctg|Bombyx_mori|ctg1
#	scaf|Bombyx_mori|scaf1
#	chr|Bombyx_mori|chr1
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
      taxa["bicyclus_anynana_nba01"] = 3993118
      taxa["bombyx_mori"] = 8023338
      taxa["chilo_suppressalis_csuogs1"] = 8177422
      taxa["danaus_plexippus"] = 8555660
      taxa["heliconius_melpomene"] = 8555662
      taxa["heliconius_melpomene_hmel2"] = 154377
      taxa["lerema_accius_v1x1"] = 8568982
      taxa["manduca_sexta_msex1"] = 8573293
      taxa["melitaea_cinxia"] = 8616757
      taxa["papilio_glaucus_v1x1"] = 155174
      taxa["pieris_napi_DAS5"] = 9250926
      taxa["plodia_interpunctella_v1"] = 8761949
      taxa["plutella_xylostella_dbmfjv1x1"] = 8770212
      taxa["Agraulis_vanillae_helico2"] = 398452
      taxa["Eueides_tales_helico2"] = 2460429
      taxa["Heliconius_besckei_helico2"] = 2990818
      taxa["Heliconius_burneyi_helico2"] = 3367821
      taxa["Heliconius_cydno_helico2"] = 3718864
      taxa["Heliconius_demeter_helico2"] = 4022736
      taxa["Heliconius_elevatus_helico2"] = 4313467
      taxa["Heliconius_erato_helico2"] = 4439085
      taxa["Heliconius_erato_himera_helico2"] = 4501982
      taxa["Heliconius_hecale_helico1"] = 4589812
      taxa["Heliconius_himera_helico1"] = 4685331
      taxa["Heliconius_melpomene_helico2"] = 6808582
      taxa["Heliconius_numata_helico2"] = 223205
      taxa["Heliconius_pardalinus_helico2"] = 8869409
      taxa["Heliconius_telesiphe_helico2"] = 938851
      taxa["Heliconius_timareta_helico2"] = 6973228
      taxa["Laparus_doris_helico2"] = 7235969
      taxa["Neruda_aoede_helico2"] = 7923715

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
        :title => 'web apollo',
        :url   => url,
        :icon  => 'fa-external-link',
        :img  => 'img/a-lepbase.png'
      }
    end


  end
end

# [1]: https://stackoverflow.com/questions/2824126/whats-the-difference-between-uri-escape-and-cgi-escape
