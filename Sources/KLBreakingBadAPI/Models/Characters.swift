///
/// Represent a Character with a name and an id
public struct Character: Codable {

    /// id the id of the character
    public let id: Int

    /// name the name of the character
    public let name: String

    enum CodingKeys: String, CodingKey {
           case id = "char_id"
           case name
       }
}
