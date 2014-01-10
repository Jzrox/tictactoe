# Encoding: utf-8

module Tictactoe
  module Player
    class PerfectPlayer
      attr_reader :piece, :board

      Node = Struct.new(:score, :move)

      def initialize(piece)
        @piece = piece
      end

      def take_turn(board)
        validate_players_turn(board)
        @board = board
        board.place_piece(piece, choose_move).hand_off
      end

      private

      def validate_players_turn(board)
        fail ArgumentError, 'It is not this player\'s turn.' if piece != board.player_piece
      end

      def choose_move
        return board.corner_spaces.sample if board.blank?
        return board.available_moves[0] if board.last_move?
        best_possible_move
      end


      def best_possible_move
        @base_score = board.number_of_spaces + 1
        minimax(board, 0, -100000, 100000)
        @current_move_choice
      end

      def minimax(board, depth, alpha, beta)
        return evaluate_state(board, depth) if board.over?
        if board.player_piece == piece
          v = min
          board.available_moves.each do |move|
            pgs = board.hand_off.place_piece(board.player_piece, move)
            v_ = minimax(pgs, depth + 1, alpha, beta)
            if v_ > v
              v = v_
              @current_move_choice = move
            end
            return beta if v > beta
          end
          return v
        else
          v = max
          board.available_moves.each do |move|
            pgs = board.hand_off.place_piece(board.player_piece, move)
            v_ = minimax(pgs, depth + 1, alpha, beta)

            if v_ < v
              v = v_
              @current_move_choice = move
            end
            return alpha if v < alpha
          end
          return alpha
        end
      end

      # def best_possible_move
      #   @base_score = board.number_of_spaces + 1
      #   minmax(board, 0)
      #   @current_move_choice
      # end

      # def minmax(node_board, depth)
      #   return evaluate_state(node_board, depth) if node_board.over?
      #   minmax_node = reduce_nodes(node_board, generate_nodes(node_board, depth))
      #   @current_move_choice = minmax_node.move
      #   minmax_node.score
      # end

      def evaluate_state(node_board, depth)
        if node_board.won?(piece)
          @base_score - depth
        elsif node_board.lost?(piece)
          depth - @base_score
        else
          0
        end
      end

      # def generate_nodes(node_board, depth)
      #   node_board.available_moves.map do |move|
      #     new_node = node_board.hand_off.place_piece(node_board.player_piece, move)
      #     Node.new minmax(new_node, depth + 1), move
      #   end
      # end

      # def reduce_nodes(node_board, nodes)
      #   nodes.reduce do |base, node|
      #     if node_board.player_piece == piece
      #       base.score > node.score ? base : node
      #     else
      #       base.score < node.score ? base : node
      #     end
      #   end
      # end
    end
  end
end
