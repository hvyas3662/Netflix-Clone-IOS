extension String {
    
    func capFristLetter() ->String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
}
