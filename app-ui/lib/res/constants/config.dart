// Auth 관련 헤더 Key, Value 관련 상수
const String jwtHeaderBearer = 'Bearer ';
const String accessTokenKey = 'ACCESS_TOKEN';
const String refreshTokenKey = 'REFRESH_TOKEN';
const String accessTokenHeaderKey = 'Authorization';
const String refreshTokenHeaderKey = 'Authorization-Refresh';
const String loginIdHeaderKey = 'loginId';
const String expiredKey = 'isExpired';
const String headerJsonValue = "application/json";

// 설정 페이지 내 링크 관련 상수
const String androidAppLink =
    'https://play.google.com/store/apps/details?id=kr.mybrary.mybrary';
const String iosAppLink =
    'https://apps.apple.com/kr/app/%EB%A7%88%EC%9D%B4%EB%B8%8C%EB%9F%AC%EB%A6%AC/id6470614390';
const String noticeAndUpdateLink =
    'https://notice.mybrary.kr/66ab3cd9-4b0a-4f89-af6c-8d2ec24056fd';
const String mybraryGuideLink =
    'https://notice.mybrary.kr/bd2a401f-b2f2-475c-a956-9b3a897c23a6';
const String inquiryLink = 'https://open.kakao.com/me/mybrary';
const String mybraryTermsLink = 'https://notice.mybrary.kr/terms-of-use';
const String mybraryPrivacyLink = 'https://notice.mybrary.kr/privacy-policy';
const String openSourceLicenseLink =
    'https://notice.mybrary.kr/de54830f-b0fc-45c6-9794-373ec8f83ef7';

// 기타 상수
const List<Map<String, String>> badgeSvg = [
  {"마이 100": "assets/svg/badge/my_100.svg"},
  {"마이 멤버": "assets/svg/badge/my_member.svg"},
  {"산뜻한 출발": "assets/svg/badge/fresh_start.svg"},
  {"탑10": "assets/svg/badge/top10.svg"},
  {"전부 읽었다냥": "assets/svg/badge/read_through.svg"},
  {"초보 리뷰어": "assets/svg/badge/beginner_reviewer.svg"},
  {"숙련된 리뷰어": "assets/svg/badge/advanced_reviewer.svg"},
  {"호기심 왕": "assets/svg/badge/curiosity_king.svg"},
  {"소통왕": "assets/svg/badge/communication_king.svg"},
  {"인플루언서": "assets/svg/badge/influencer.svg"},
  {"등록왕": "assets/svg/badge/registration_king.svg"},
  {"완독왕": "assets/svg/badge/completed_king.svg"},
];

const List<String> badgeContent = [
  "마이브러리와 함께한지 100일 지났습니다.\n계속 저희와 함께 해주실거죠?",
  "회원가입을 축하드립니다!\n마이브러리 멤버로 열심히 활동해주세요 :)",
  "도서를 처음 등록해주셨군요!\n앞으로도 많은 등록 기대할게요 :)",
  "마이브러리의 초기 탑10 멤버!\n저희와 함께 끝까지 달리실거죠?",
  "등록한 도서를 모두 읽었다냥\n앞으로도 꾸준히 도서를 읽어달라냥",
  "리뷰를 1개 이상 작성해주셨군요!\n더 많은 리뷰를 작성하러 가볼까요?",
  "리뷰를 15개 이상 작성해주셨군요!\n앞으로도 많은 리뷰 부탁드릴게요 :)",
  "관심도서를 10권 이상 등록해주셨군요!\n당신을 호기심의 왕으로 임명합니다 :)",
  "교환 또는 나눔 도서를 10권 이상 등록해주셨군요!\n도서의 가치를 아는 당신이 바로 소통왕 :)",
  "팔로워 수가 100명을 돌파하셨군요!\n인플루언서가 될 준비 되셨나요?",
  "도서를 10권 이상 등록해주셨군요!\n책을 좋아하는 당신 혹시.. 등록왕 ?!",
  "완독한 도서가 10권 이상이군요!\n당신은 이 시대의 진정한 완독왕 :)",
];
