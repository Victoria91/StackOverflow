shared_examples_for 'Authentication-requireable' do
  it 'redirects unauthorized' do
    request
    expect(response.status).to eq(401)
  end
end