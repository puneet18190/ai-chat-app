# app/services/rag_service.rb

class RagService
  def self.ask(query)
    docs = Document.all

    # simple keyword matching (no vector DB)
    scored = docs.map do |doc|
      score = similarity(query, doc.content)
      { content: doc.content, score: score }
    end

    Rails.logger.info "scored: #{scored}"

    top_docs = scored.sort_by { |d| -d[:score] }.first(3)

    context = top_docs.map { |d| d[:content] }.join("\n")

    Rails.logger.info "context: #{context}"

    prompt = <<~PROMPT
      Answer the question using the context below:

      Context:
      #{context}

      Question:
      #{query}
    PROMPT

    GeminiClient.ask(prompt)
  end

  def self.similarity(a, b)
    a_words = a.downcase.split
    b_words = b.downcase.split

    (a_words & b_words).size
  end
end