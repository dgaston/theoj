require "rails_helper"

describe FullPaperSerializer do

  it "should initialize properly" do
    user = create(:user)

    paper = Paper.new(location:"http://example.com", title:"Teh awesomeness", submittor:user)
    serializer = FullPaperSerializer.new(paper)
    hash = hash_from_json(serializer.to_json)

    expect(hash.keys).to contain_exactly("id", "arxiv_id", "version",
                                        "user_permissions", "location", "state",
                                        "submitted_at", "title",
                                        "pending_issues_count",
                                        "sha",
                                        "assigned_users", "versions")
  end

  it "should serialize a list of assignments" do
    set_paper_editor create(:editor, name:'An Editor')
    paper    = create(:paper, submittor:create(:user, name:'The Submittor'), reviewer:create(:user,name:'The Reviewer') )

    serializer = FullPaperSerializer.new(paper)
    assignments = hash_from_json(serializer.to_json)['assigned_users']

    expect(assignments[0]['role']).to eq('editor')
    expect(assignments[0]['user']['name']).to eq('An Editor')
    expect(assignments[1]['role']).to eq('submittor')
    expect(assignments[1]['user']['name']).to eq('The Submittor')
    expect(assignments[2]['role']).to eq('reviewer')
    expect(assignments[2]['user']).to be_nil
  end

  it "should serialize a list of versions" do
    paper1 = create(:paper, arxiv_id:'1111.2222', version:1 )
    paper2 = create(:paper, arxiv_id:'1111.2222', version:2 )
    paper3 = create(:paper, arxiv_id:'1111.2222', version:3 )

    serializer = FullPaperSerializer.new(paper2)
    versions = hash_from_json(serializer.to_json)['versions']

    expect(versions[0]['version']).to eq(3)
    expect(versions[1]['version']).to eq(2)
    expect(versions[2]['version']).to eq(1)
  end

end