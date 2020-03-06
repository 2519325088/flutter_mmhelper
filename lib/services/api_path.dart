
class APIPath {
  static String newCandidate(String contentId) => 'mb_content/$contentId';
  static String candidateList() => 'fl_content';
  static String imageFirebaseData(String imageId) => 'fl_files/$imageId';

}