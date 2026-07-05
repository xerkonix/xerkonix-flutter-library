# xerkonix-flutter-library

XERKONIX Flutter 공개 패키지 5종의 모노레포. 모두 pub.dev 에 게시된 Apache-2.0 오픈소스이며, Weave 디자인 시스템과 공통 앱 인프라(에러/HTTP/로깅/사이징)를 제공한다.

이 패키지들은 **오픈소스 레퍼런스**다. XERKONIX 제품 서비스는 의도적으로 이 패키지들에 런타임 의존하지 않고, 공유 계약(`xerkonix-code-contract`)에서 코드를 생성해 각자 소유하는 방식을 쓴다(`xerkonix-frontend-boilerplate` 참고). 즉 이 라이브러리는 공개·참조용이고, 제품은 패키지 비종속이다.

## 패키지

| 패키지 (pub 이름) | 버전 | 요약 |
|---|---|---|
| [`xerkonix_design_system`](xerkonix-design-system/) | 2.1.1 | Weave v1.5 토큰·테마·타이포·아이콘·컴포넌트·패턴·모션 위젯 |
| [`xerkonix_error_handler`](xerkonix-error-handler/) | 1.1.0 | 구조화된 에러 타입·예외·메시지 핸들러·다이얼로그/토스트 UI |
| [`xerkonix_http`](xerkonix-http/) | 1.1.0 | 전 HTTP 메서드 클라이언트 + 자동 에러 파싱·로깅 통합 |
| [`xerkonix_logger`](xerkonix-logger/) | 1.1.0 | 레벨별 로깅 + HTTP 요청/응답 로깅 |
| [`xerkonix_sizer`](xerkonix-sizer/) | 1.1.0 | 논리 픽셀(lp) 기반 반응형 사이징 유틸리티 |

각 패키지는 독립적으로 게시된다. `xerkonix_http` 는 `xerkonix_error_handler` / `xerkonix_logger` 에, `xerkonix_error_handler` 는 `xerkonix_logger` 에 의존한다.

## 요구 사항

- Dart SDK: `>=3.5.0 <4.0.0`
- Flutter: `>=3.24.0`

## 구조

```
xerkonix-flutter-library/
├── xerkonix-design-system/   # 디자인 시스템
├── xerkonix-error-handler/   # 에러 처리
├── xerkonix-http/            # HTTP 클라이언트
├── xerkonix-logger/          # 로깅
└── xerkonix-sizer/           # 반응형 사이징
```

각 패키지의 예제는 해당 패키지 `example/` 폴더에 있다. 개발/검증은 패키지 디렉터리에서:

```bash
cd <package>
flutter pub get
flutter analyze
flutter test
```

## 라이선스

모든 패키지는 Apache License 2.0. 각 패키지의 `LICENSE` 파일 참고.
