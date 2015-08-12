# encoding: utf-8
require 'spec_helper'

include Bucky::TransactionImports

describe Bucky::TransactionImports::OmniImport do
  it 'should import the correct rows' do
    expect(Bucky::TransactionImports::OmniImport.test.process).to eq([{ :DATE => "15/01/2015",
                                                                        :DESC => "DEB '77-22-08 26108268 WWW.WELSHFRUITSTOC CD 7115 ",
                                                                        :AMOUNT => "27.5",
                                                                        :raw_data => { :date => "15/01/2015",
                                                                                       :trans_type => "DEB",
                                                                                       :sort_code => "'77-22-08",
                                                                                       :account_number => "26108268",
                                                                                       :description => "WWW.WELSHFRUITSTOC CD 7115 ",
                                                                                       :debt_amount => nil,
                                                                                       :credit_amount => "27.5" } },
                                                                      { :DATE => "15/01/2015",
                                                                        :DESC => "FPI '77-22-08 26108268 DULEY LMM DULEY - THURSDAY 198959821141512001 ",
                                                                        :AMOUNT => "24",
                                                                        :raw_data => { :date => "15/01/2015",
                                                                                       :trans_type => "FPI",
                                                                                       :sort_code => "'77-22-08",
                                                                                       :account_number => "26108268",
                                                                                       :description => "DULEY LMM DULEY - THURSDAY 198959821141512001 ",
                                                                                       :debt_amount => nil,
                                                                                       :credit_amount => "24" } },
                                                                      { :DATE => "15/01/2015",
                                                                        :DESC => "FPI '77-22-08 26108268 MS RUSSELL & DOCTO CHRISTIE 000000000026803143 ",
                                                                        :AMOUNT => "16",
                                                                        :raw_data => { :date => "15/01/2015",
                                                                                       :trans_type => "FPI",
                                                                                       :sort_code => "'77-22-08",
                                                                                       :account_number => "26108268",
                                                                                       :description => "MS RUSSELL & DOCTO CHRISTIE 000000000026803143 ",
                                                                                       :debt_amount => nil,
                                                                                       :credit_amount => "16" } },
                                                                      { :DATE => "15/01/2015",
                                                                        :DESC => "FPI '77-22-08 26108268 WARD MJ&HE     PBM WARDEAKRING 53024055720433000N ",
                                                                        :AMOUNT => "12",
                                                                        :raw_data => { :date => "15/01/2015",
                                                                                       :trans_type => "FPI",
                                                                                       :sort_code => "'77-22-08",
                                                                                       :account_number => "26108268",
                                                                                       :description => "WARD MJ&HE     PBM WARDEAKRING 53024055720433000N ",
                                                                                       :debt_amount => nil,
                                                                                       :credit_amount => "12" } },
                                                                      { :DATE => "15/01/2015",
                                                                        :DESC => "CHQ '77-22-08 26108268 44",
                                                                        :AMOUNT => "-217.5",
                                                                        :raw_data => { :date => "15/01/2015",
                                                                                       :trans_type => "CHQ",
                                                                                       :sort_code => "'77-22-08",
                                                                                       :account_number => "26108268",
                                                                                       :description => "44",
                                                                                       :debt_amount => "217.5",
                                                                                       :credit_amount => nil } },
                                                                      { :DATE => "15/01/2015",
                                                                        :DESC => "DD '77-22-08 26108268 LONDON&ZURICHPLC 008798 ",
                                                                        :AMOUNT => "-54.14",
                                                                        :raw_data => { :date => "15/01/2015",
                                                                                       :trans_type => "DD",
                                                                                       :sort_code => "'77-22-08",
                                                                                       :account_number => "26108268",
                                                                                       :description => "LONDON&ZURICHPLC 008798 ",
                                                                                       :debt_amount => "54.14",
                                                                                       :credit_amount => nil } },
                                                                      { :DATE => "15/01/2015",
                                                                        :DESC => "SO '77-22-08 26108268 T BLOWER BLOWER ",
                                                                        :AMOUNT => "21.4",
                                                                        :raw_data => { :date => "15/01/2015",
                                                                                       :trans_type => "SO",
                                                                                       :sort_code => "'77-22-08",
                                                                                       :account_number => "26108268",
                                                                                       :description => "T BLOWER BLOWER ",
                                                                                       :debt_amount => nil,
                                                                                       :credit_amount => "21.4" } },
                                                                      { :DATE => "14/01/2015",
                                                                        :DESC => "FPI '77-22-08 26108268 JACKSON & JACKSON SUZY JACKSON 31023454163603000N ",
                                                                        :AMOUNT => "21",
                                                                        :raw_data => { :date => "14/01/2015",
                                                                                       :trans_type => "FPI",
                                                                                       :sort_code => "'77-22-08",
                                                                                       :account_number => "26108268",
                                                                                       :description => "JACKSON & JACKSON SUZY JACKSON 31023454163603000N ",
                                                                                       :debt_amount => nil,
                                                                                       :credit_amount => "21" } },
                                                                      { :DATE => "13/01/2015",
                                                                        :DESC => "FPI '77-22-08 26108268 DULEY LMM DULEY - THURSDAY 291934914412312001 ",
                                                                        :AMOUNT => "24",
                                                                        :raw_data => { :date => "13/01/2015",
                                                                                       :trans_type => "FPI",
                                                                                       :sort_code => "'77-22-08",
                                                                                       :account_number => "26108268",
                                                                                       :description => "DULEY LMM DULEY - THURSDAY 291934914412312001 ",
                                                                                       :debt_amount => nil,
                                                                                       :credit_amount => "24" } },
                                                                      { :DATE => "13/01/2015",
                                                                        :DESC => "DEB '77-22-08 26108268 HORTICULTURAL SPPL CD 7115 ",
                                                                        :AMOUNT => "-372",
                                                                        :raw_data => { :date => "13/01/2015",
                                                                                       :trans_type => "DEB",
                                                                                       :sort_code => "'77-22-08",
                                                                                       :account_number => "26108268",
                                                                                       :description => "HORTICULTURAL SPPL CD 7115 ",
                                                                                       :debt_amount => "372",
                                                                                       :credit_amount => nil } },
                                                                      { :DATE => "13/01/2015",
                                                                        :DESC => "FPI '77-22-08 26108268 STEVENSON N M NATASHA RP4659983979662400 ",
                                                                        :AMOUNT => "10",
                                                                        :raw_data => { :date => "13/01/2015",
                                                                                       :trans_type => "FPI",
                                                                                       :sort_code => "'77-22-08",
                                                                                       :account_number => "26108268",
                                                                                       :description => "STEVENSON N M NATASHA RP4659983979662400 ",
                                                                                       :debt_amount => nil,
                                                                                       :credit_amount => "10" } }])
  end

  it 'should skip the correct rows' do
    Bucky::TransactionImports::OmniImport.test2.process.each do |row|
      expect(row[:DESC]).not_to eq("Opening Balance")
      expect(row[:DESC]).not_to eq("Closing Balance")
    end
  end

  it 'should skip all but Completed rows' do
    Bucky::TransactionImports::OmniImport.test_paypal.process.each do |row|
      expect(row[:raw_data][:status]).to eq("Completed")
    end
  end

  it 'should handle ISO8859-1 encoding' do
    rows = Bucky::TransactionImports::OmniImport.csv_read(File.join(Rails.root, "spec/support/test_upload_files/transaction_imports/TLVB-Accounts02Aug13.csv"))
    expect(rows[0]).to eq %w(Date Transaction Deposits Withdrawals)
    expect(rows[1]).to eq ["02/08/13", "MR SIMON J MORLEY", "£5.00", " "]
  end

  it 'should handle shitty windows excel csv format' do
    rows = Bucky::TransactionImports::OmniImport.csv_read(File.join(Rails.root, "spec/support/test_upload_files/transaction_imports/TheLocalVegBoxBank19Jul13.csv"))
    expect(rows[0]).to eq %w(Date Transaction Deposits Withdrawals)
    expect(rows[1]).to eq ["19/07/2013", "MR SIMON J MORLEY", "£5.00", nil]
  end

  context "when the CSV separator is a semi-colon" do
    it "parses the CSV properly" do
      rows = Bucky::TransactionImports::OmniImport.csv_read(File.join(Rails.root, "spec/support/test_upload_files/transaction_imports/polynesie_semi-colon.csv"))
      expect(rows[0]).to eq ["Date comptable", "Libelle", "Date valeur", "Montant", "Code operation"]
      expect(rows[1]).to eq ["13/06/2015", "VIRT VIRT DE BRASSERIE DE TAHITI FC.02/06", "2015-06-13", "156870", "VIR"]
    end
  end

  describe ".find_file_endocing" do
    let(:file)              { double("file") }
    let(:encoding_detector) { double("encoding_detector") }
    let(:omni_import)       { Bucky::TransactionImports::OmniImport }

    it "returns an encoding if the first result has an encoding" do
      result_hash = [
        { type: :text, encoding: "windows-1252", confidence: 100, language: "en" },
      ]
      allow(encoding_detector).to receive(:detect_all) { result_hash }
      expect(omni_import.find_file_encoding(file, encoding_detector)).to eq("windows-1252")
    end

    it "returns the next best encoding if the first result does not have an encoding" do
      result_hash = [
        { type: :binary, confidence: 100 },
        { type: :text, encoding: "windows-1252", confidence: 36, language: "en" }
      ]
      allow(encoding_detector).to receive(:detect_all) { result_hash }
      expect(omni_import.find_file_encoding(file, encoding_detector)).to eq("windows-1252")
    end

    it "returns nil if there were no encodings found" do
      result_hash = [
        { type: :binary, confidence: 100 },
      ]
      allow(encoding_detector).to receive(:detect_all) { result_hash }
      expect(omni_import.find_file_encoding(file, encoding_detector)).to eq(nil)
    end

    it "returns nil if there were no results found" do
      result_hash = []
      allow(encoding_detector).to receive(:detect_all) { result_hash }
      expect(omni_import.find_file_encoding(file, encoding_detector)).to eq(nil)
    end
  end
end
