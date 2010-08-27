require File.expand_path( File.dirname(__FILE__) + '/spec_helper' )

describe 'Grantprix' do

  describe 'Builder' do
  
    before { @builder = Grantprix::Builder.new }
    
    it 'should initialize with given :privileges' do
      builder = Grantprix::Builder.new( 'select' )
      builder.to_s.should  == 'GRANT SELECT'
    end
    
    describe ':grant' do
      it 'should return the builder' do
        @builder.grant( :test ).should == @builder
      end
      
      it 'should allow multiple privileges' do
        @builder.grant :select, :insert
        @builder.to_s.should == 'GRANT SELECT, INSERT'
      end
      
      it 'should accumulate privileges' do
        @builder.grant( :select )
        @builder.grant( :insert )
        
        @builder.to_s.should  == 'GRANT SELECT, INSERT'
      end
    end
    
    describe ':on' do
      it 'should return the builder' do
        @builder.on( :test ).should == @builder
      end
      
      it 'should default to TABLE' do
        @builder.on( 'table_name' )
        @builder.to_s.should  == 'ON TABLE table_name'
      end
      
      it 'should allow to specify the database object' do
        @builder.on( :database, 'db_name' )
        @builder.to_s.should  == 'ON DATABASE db_name'
      end
      
      it 'should accumulate the options' do
        @builder.on( 'table1' )
        @builder.on( 'table2' )
        @builder.to_s.should  == 'ON TABLE table1, table2'
      end
      
      it 'should not allow to change the database object' do
        @builder.on( :table, 'table' )
        lambda { @builder.on( :database, 'db' ) }.should raise_error( Grantprix::NotAllowed )
      end
    end
    
    describe ':to' do
      it 'should return the builder' do
        @builder.to( :test ).should == @builder
      end
      
      it 'should allow multiple users' do
        @builder.to( 'user1', 'user2' )
        @builder.to_s.should == 'TO user1, user2'
      end
      
      it 'should accumulate the options' do
        @builder.to( 'user1' )
        @builder.to( 'user2' )
        @builder.to_s.should == 'TO user1, user2'
      end
      
      it 'should trat :group separately' do
        @builder.to( :group, 'groupname' )
        @builder.to_s.should == 'TO GROUP groupname'
      end
      
      it 'should treat :public separately' do
        @builder.to( :public )
        @builder.to_s.should == 'TO PUBLIC'
      end
    end
    
    describe ':with' do
      it 'should return the builder' do
        @builder.with( :test ).should == @builder
      end
      
      it 'should convert :grant_option correctly' do
        @builder.with( :grant_option )
        @builder.to_s.should == 'WITH GRANT OPTION'
      end
      
      it 'should convert :admin_option correctly' do
        @builder.with( :admin_option )
        @builder.to_s.should == 'WITH ADMIN OPTION'
      end
    end
    
  end
  
  describe '#grant' do
    it 'should allow to concat given statements' do
      g = Grantprix.grant( 'all' ).on( 'table1' ).to( 'user1' )
      g.to_s.should == 'GRANT ALL ON TABLE table1 TO user1'
    end
    
    it 'should have some more tests here'
  end
  
end
