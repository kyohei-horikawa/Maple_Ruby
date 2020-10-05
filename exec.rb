require "./Maple"

maple = Maple.new

# #1番シンプルなテスト
# maple.define_symbol("x", 5)
# maple.define_calc("x", "*", 6)
# p maple.exec_command

# # 複数行の場合latexを用いるテスト
# maple.define_symbol("y", "x^2+4*x+6")
# maple.latex_solve("y", "x")
# puts maple.exec_command

#plotのテスト
maple.define_symbol("y", "x^2+4*x+6")
maple.plot("y", -3, 3)

# maple.define_symbol("y", "x^2+4*x+4")
# maple.latex_factor("y")
# puts maple.exec_command
