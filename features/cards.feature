Feature: Cards are differently named
    Background:
      Given a file named "cards.rb" with:
      """
      class Card
        def hearts
          puts "hearts"
        end

        def clubs
          puts "clubs"
        end

        def diamonds
          puts "diamonds"
        end
      end

      card = Card.new

      card.hearts

      card.clubs
      """

    Scenario: Hearts cards
      When I run `ruby cards.rb`
      Then the output should contain:
      """
      hearts
      """

    Scenario: Clubs cards
      When I run `ruby cards.rb`
      Then the output should contain:
      """
      clubs
      """
