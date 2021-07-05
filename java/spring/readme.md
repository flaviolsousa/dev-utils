# Spring

# Start a new project:

http://start.spring.io/

## Mind Triggers

### Commons Annotations:

```
@SpringBootApplication
@ImportResource({"classpath*:spring-config.xml"})
@Component
@Controller
@RestController
@Service
@Repository
@Configuration
@PropertySource("classpath:config.properties")
@Bean
@Profile
@Primary
@Qualifier
@Autowired
@PostConstruct
@PreDestroy
@RequestMapping("/books")
@ResponseBody
```

### Commons application.properties:

```properties
spring.profiles.active=en
```

### LifeCycleBean:

```
# constructor
BeanNameAware
BeanClassLoaderAware
BeanFactoryAware
@PostConstruct
InitializingBean
@PreDestroy
DisposableBean
```

### Resources:

#### DevBootstrap

```java
@Component
public class DevBootstrap implements ApplicationListener<ContextRefreshedEvent> {
    ...
	@Override
	public void onApplicationEvent(ContextRefreshedEvent event) {
		initData();
	}

	private void initData() {
		Publisher publisher = new Publisher();
		publisher.setName("Foo");

		publisherRepository.save(publisher);
	}
    ...
```

#### CrudRepository

```java
public interface PublisherRepository extends CrudRepository<Publisher, Long>{

}
```

### Using: @PropertySource and @value

PropertySourcesPlaceHolderConfigurer Bean only required for @Value("{}") annotations.
Remove this bean if you are not using @Value annotations for injecting properties.

```java
    @Bean
    public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
        return new PropertySourcesPlaceholderConfigurer();
    }
```
