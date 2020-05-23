
class APIPath {
  static String newCandidate(String contentId) => 'mb_content/$contentId';
  static String newProfile(String contentId) => 'mb_profile/$contentId';
  static String newContract(String contentId) => 'mb_contract/$contentId';
  static String updateJob(String contentId) => 'fl_job_post/$contentId';
  static String newJob(String contentId) => 'fl_job_post';
  static String newQuestionResult(String contentId) => 'mb_question_result/$contentId';
  static String jobList() => 'fl_job_post';
  static String userList() => 'mb_content';
  static String candidateList() => 'mb_profile';
  static String educationList() => 'mb_education_list';
  static String religionList() => 'mb_religion_list';
  static String maritalList() => 'mb_marital_list';
  static String childrenList() => 'mb_children_list';
  static String jobTypeList() => 'mb_jobType_list';
  static String jobCapList() => 'mb_jobCap_list';
  static String contractList() => 'mb_contract_list';
  static String workSkillList() => 'mb_workSkill_list';
  static String langList() => 'mb_lang_list';
  static String nationalityList() => 'mb_nationality_list';
  static String locationList() => 'mb_location_list';
  static String roleList() => 'mb_role_list';
  static String accommodationList() => 'mb_accommodation_list';
  static String weekHolidayList() => 'mb_holidayno_list';
  static String quitReasonList() => 'mb_quit_reason';
  static String quitReasonHkList() => 'mb_quit_reason_hk';
  static String imageFirebaseData(String imageId) => 'fl_files/$imageId';

}