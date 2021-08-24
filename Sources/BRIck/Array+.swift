
/// Array extensions.
extension Array {
	/// Remove the given element from this array, by comparing pointer references.
	///
	/// - parameter element: The element to remove.
	public mutating func removeElementByReference(_ element: Element) {
		guard let objIndex = firstIndex(where: { $0 as AnyObject === element as AnyObject }) else {
			return
		}
		remove(at: objIndex)
	}
}
