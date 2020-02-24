
class APIPath {
  static String newCandidate(String contentId) => 'fl_content/$contentId';
  static String candidateList() => 'fl_content';
  static String imageFirebaseData(String imageId) => 'fl_files/$imageId';

}